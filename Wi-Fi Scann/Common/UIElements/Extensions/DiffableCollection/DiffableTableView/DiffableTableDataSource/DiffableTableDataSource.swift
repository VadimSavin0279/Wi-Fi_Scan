import UIKit
import Combine

final class DiffableTableDataSource<
    Section: DiffableTableSection,
    Item: DiffableTableItem
>: UITableViewDiffableDataSource<Section, Item> {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias DataSource = UITableViewDiffableDataSource<Section, Item>
    
    var canEditItem: IOClosure<(item: Item, ip: IndexPath), Bool>?
    var canReorderItem: IOClosure<(item: Item, ip: IndexPath), Bool>?
    
    var sourceDidChange: AnyPublisher<Void, Never> {
        sourceDidChangeSubject.eraseToAnyPublisher()
    }
    
    var didDeleteItem: AnyPublisher<Item, Never> {
        didDeleteItemSubject.eraseToAnyPublisher()
    }
    
    var willDeleteItem: AnyPublisher<Item, Never> {
        willDeleteItemSubject.eraseToAnyPublisher()
    }
    
    private let sourceDidChangeSubject = PassthroughSubject<Void, Never>()
    private let didDeleteItemSubject = PassthroughSubject<Item, Never>()
    private let willDeleteItemSubject = PassthroughSubject<Item, Never>()
    
    init(tableView: UITableView,
         canEditItem: IOClosure<(item: Item, ip: IndexPath), Bool>? = nil,
         canReorderItem: IOClosure<(item: Item, ip: IndexPath), Bool>? = nil) {
        self.canEditItem = canEditItem
        self.canReorderItem = canReorderItem
        
        super.init(tableView: tableView) { tableView, indexPath, item in
            let identifier = item.reuseIdentifier
            let cell = tableView.dequeueReusableCell(
                withIdentifier: identifier,
                for: indexPath
            )
            item.configure(cell: cell, indexPath: indexPath)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool {
        guard let item = itemIdentifier(for: indexPath) else {
            return false
        }
        return canEditItem?((item, indexPath)) ?? false
    }
    
    override func tableView(_ tableView: UITableView,
                            canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let item = itemIdentifier(for: indexPath) else {
            return false
        }
        return canReorderItem?((item, indexPath)) ?? false
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        guard let from = itemIdentifier(for: sourceIndexPath),
                sourceIndexPath != destinationIndexPath
        else {
            return
        }
        
        var snap = snapshot()
        snap.deleteItems([from])
        
        if let to = itemIdentifier(for: destinationIndexPath) {
            let isAfter = destinationIndexPath.row > sourceIndexPath.row
            if isAfter {
                snap.insertItems([from], afterItem: to)
            } else {
                snap.insertItems([from], beforeItem: to)
            }
        } else {
            snap.appendItems([from], toSection: sectionId(by: sourceIndexPath))
        }
        
        applyAndSend(snapshot: snap, animated: false)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard let item = itemIdentifier(for: indexPath) else { return }
        switch editingStyle {
        case .delete:
            willDeleteItemSubject.send(item)
            delete(items: [item], animated: true)
            didDeleteItemSubject.send(item)
        default:
            break
        }
    }
    
    // MARK: - Private methods
    
    private func sectionId(by indexPath: IndexPath) -> Section {
        snapshot().sectionIdentifiers[indexPath.section]
    }
    
    private func applyAndSend(snapshot: Snapshot, animated: Bool) {
        apply(snapshot, animatingDifferences: animated)
        self.sourceDidChangeSubject.send(())
    }
}

extension DiffableTableDataSource: DiffableTable {
    var sections: [Section] {
        return snapshot().sectionIdentifiers
    }
    
    func itemsCount(section: Section) -> Int {
        let snapshot = snapshot()
        guard snapshot.indexOfSection(section) != nil else {
            return 0
        }
        return snapshot.numberOfItems(inSection: section)
    }
    
    func items(in section: Section) -> [Item] {
        let snapshot = snapshot()
        guard snapshot.indexOfSection(section) != nil else {
            return []
        }
        return snapshot.itemIdentifiers(inSection: section)
    }
    
    func reload(_ sections: [DiffableTableSectionModel<Section, Item>], animated: Bool) {
        var snapshot = snapshot()
        sections
            .sorted(by: { $0.section.sectionIndex < $1.section.sectionIndex })
            .forEach { model in
                
                if !snapshot.sectionIdentifiers.contains(model.section) {
                    snapshot.appendSections([model.section])
                }
                
                let currentIdentifiers = snapshot.itemIdentifiers(inSection: model.section)
                let diff = model.items.difference(from: currentIdentifiers)
                guard let newIdentifiers = currentIdentifiers.applying(diff) else {
                    return
                }
                snapshot.deleteItems(currentIdentifiers)
                snapshot.appendItems(newIdentifiers)
            }
        
        applyAndSend(snapshot: snapshot, animated: animated)
    }
    
    func reloadData(_ sections: [DiffableTableSectionModel<Section, Item>], animated: Bool) {
        var snapshot = Snapshot()
        sections.forEach { model in
            snapshot.appendSections([model.section])
            snapshot.appendItems(model.items, toSection: model.section)
        }
        applyAndSend(snapshot: snapshot, animated: animated)
    }
    
    func append(
        items: [Item],
        to section: Section,
        animated: Bool
    ) {
        var snapshot = snapshot()
        if !snapshot.sectionIdentifiers.contains(section) {
            snapshot.appendSections([section])
        }
        snapshot.appendItems(items, toSection: section)
        applyAndSend(snapshot: snapshot, animated: animated)
    }
    
    func delete(items: [Item], animated: Bool) {
        var snapshot = snapshot()
        snapshot.deleteItems(items)
        applyAndSend(snapshot: snapshot, animated: animated)
    }
    
    func deleteAll(animated: Bool) {
        applyAndSend(snapshot: Snapshot(), animated: animated)
    }
}
