import UIKit

final class DiffableTableViewDelegateProxy: NSObject, UITableViewDelegate {
    
    var identifierForHeaderInSection: IOClosure<Int, StringIdentifier?>?
    var heightForHeaderInSection: IOClosure<Int, CGFloat?>?
    var models: [SectionModel]
    init(models: [SectionModel]) {
        self.models = models
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let identifier = identifierForHeaderInSection?(section),
              let model = models[safe: section],
              let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) else {
            return nil
            
        }
        model.configure(section: header)
        return header
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return heightForHeaderInSection?(section) ?? 0
    }
}
