import UIKit

protocol DiffableTableSection: DiffableViewItem {
    var sectionIndex: Int { get }
}
