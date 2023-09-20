import UIKit
import Combine

final class DiffableCollectionDataSource<
    Section: DiffableTableSection,
    Item: DiffableCollectionItem
>: UICollectionViewDiffableDataSource<Section, Item> {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
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
    
    init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, item in
            let identifier = item.reuseIdentifier
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
            item.configure(cell: cell, indexPath: indexPath)
            return cell
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

extension DiffableCollectionDataSource: DiffableCollection {
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
    
    func reload(_ sections: [DiffableCollectionSectionModel<Section, Item>], animated: Bool) {
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
    
    func reloadData(_ sections: [DiffableCollectionSectionModel<Section, Item>], animated: Bool) {
        var snapshot = Snapshot()
        sections.forEach { model in
            snapshot.appendSections([model.section])
            snapshot.appendItems(model.items, toSection: model.section)
        }
        applyAndSend(snapshot: snapshot, animated: animated)
    }
    
    func append(_ sections: [DiffableCollectionSectionModel<Section, Item>], animated: Bool) {
        var snapshot = snapshot()
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
    
    func append(section: Section, items: [Item], animated: Bool) {
        var snapshot = snapshot()
        if !snapshot.sectionIdentifiers.contains(section) {
            snapshot.appendSections([section])
        }
        snapshot.appendItems(items, toSection: section)
        applyAndSend(snapshot: snapshot, animated: animated)
    }
    
    func insert(_ sections: [DiffableCollectionSectionModel<Section, Item>], animated: Bool) {
        var snapshot = snapshot()
        
        guard let firstSection = snapshot.sectionIdentifiers.first else { return }
        
        sections.forEach { model in
            snapshot.insertSections([model.section], beforeSection: firstSection)
            snapshot.appendItems(model.items, toSection: model.section)
        }
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
