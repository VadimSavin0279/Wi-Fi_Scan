import UIKit

protocol DiffableCollectionItem: DiffableViewItem, StringReuseIdentifiable {
    func configure(cell: UICollectionViewCell, indexPath: IndexPath)
}
