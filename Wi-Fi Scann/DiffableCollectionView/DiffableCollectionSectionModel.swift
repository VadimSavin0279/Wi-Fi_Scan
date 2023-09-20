import Foundation

struct DiffableCollectionSectionModel<S: DiffableTableSection, I: DiffableCollectionItem> {
    let section: S
    let items: [I]
    
    init(section: S, items: [I]) {
        self.section = section
        self.items = items
    }
    
    init(section: S, item: I) {
        self.section = section
        self.items = [item]
    }
}
