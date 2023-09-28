import Foundation

protocol DiffableCollection: AnyObject {
    
    associatedtype Section: DiffableTableSection
    associatedtype Item: DiffableCollectionItem
    
    var sections: [Section] { get }
    
    func itemsCount(section: Section) -> Int
    
    func items(in section: Section) -> [Item]
    
    func reload(
        _ sections: [DiffableCollectionSectionModel<Section, Item>],
        animated: Bool
    )
    
    func reloadData(_ sections: [DiffableCollectionSectionModel<Section, Item>],
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

extension DiffableCollection {
    func reload(section: Section, with items: [Item], animated: Bool) {
        let section = DiffableCollectionSectionModel(section: section, items: items)
        self.reload([section], animated: animated)
    }
    
    func reloadData(section: Section, with items: [Item], animated: Bool) {
        let section = DiffableCollectionSectionModel(section: section, items: items)
        self.reloadData([section], animated: animated)
    }
    
    func reloadSameData(animated: Bool) {
        let sections = self.sections.map {
            DiffableCollectionSectionModel(section: $0, items: self.items(in: $0))
        }
        reloadData(sections, animated: animated)
    }
}
