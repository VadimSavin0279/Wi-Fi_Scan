import Foundation

protocol DiffableTable: AnyObject {
    
    associatedtype Section: DiffableTableSection
    associatedtype Item: DiffableTableItem
    
    var sections: [Section] { get }
    
    func itemsCount(section: Section) -> Int
    
    func items(in section: Section) -> [Item]
    
    func reload(
        _ sections: [DiffableTableSectionModel<Section, Item>],
        animated: Bool
    )
    
    func reloadData(_ sections: [DiffableTableSectionModel<Section, Item>],
                    animated: Bool)
    
    func append(
        items: [Item],
        to section: Section,
        animated: Bool
    )
    
    func delete(
        items: [Item],
        animated: Bool
    )
    
    func deleteAll(animated: Bool)
}

extension DiffableTable {
    func reload(section: Section, with items: [Item], animated: Bool) {
        let section = DiffableTableSectionModel(section: section, items: items)
        self.reload([section], animated: animated)
    }
    
    func reloadData(section: Section, with items: [Item], animated: Bool) {
        let section = DiffableTableSectionModel(section: section, items: items)
        self.reloadData([section], animated: animated)
    }
    
    func reloadSameData(animated: Bool) {
        let sections = self.sections.map {
            DiffableTableSectionModel(section: $0, items: self.items(in: $0))
        }
        reloadData(sections, animated: animated)
    }
}
