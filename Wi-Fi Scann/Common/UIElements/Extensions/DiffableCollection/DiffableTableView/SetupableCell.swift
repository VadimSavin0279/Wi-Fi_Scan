import UIKit

protocol SetupableCell: AnyObject, StaticStringIdentifiable {
    associatedtype Model
    
    func setup(model: Model)
}

extension UITableViewCell {
    func setup<Cell>(
        _ cellType: Cell.Type,
        model: Cell.Model
    ) where Cell: SetupableCell {
        guard let cell = self as? Cell else {
            assertionFailure("unable to convert into type \(type(of: cellType))")
            return
        }
        
        cell.setup(model: model)
    }
}

extension UIView {
    func setupHeader<Cell>(
        _ cellType: Cell.Type,
        model: Cell.Model
    ) where Cell: SetupableCell {
        guard let cell = self as? Cell else {
            assertionFailure("unable to convert into type \(type(of: cellType))")
            return
        }
        
        cell.setup(model: model)
    }
}

extension UICollectionViewCell {
    func setup<Cell>(
        _ cellType: Cell.Type,
        model: Cell.Model
    ) where Cell: SetupableCell {
        guard let cell = self as? Cell else {
            assertionFailure("unable to convert into type \(type(of: cellType))")
            return
        }
        
        cell.setup(model: model)
    }
}
