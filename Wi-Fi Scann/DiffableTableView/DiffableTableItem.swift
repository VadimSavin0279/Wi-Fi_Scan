import UIKit

protocol DiffableTableItem: DiffableViewItem, StringReuseIdentifiable {
    func configure(cell: UITableViewCell, indexPath: IndexPath)
}
