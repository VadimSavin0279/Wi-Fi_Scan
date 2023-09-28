import UIKit

protocol ScanMainRouter: AnyObject {
    func openResult(devices: [LANDevice])
}

final class ScanMainRouterImpl: BaseScreenRouter, ScreenRouter {
    var screen: UIViewController { _screen }
    let routerIdentifiable: RouterIdentifiable = RouterType.rootTab(.scanner)
    let presentationType: ScreenPresentationType = .plain
    
    private lazy var _screen: UIViewController = {
        let presenter = ScanMainPresenter()
        presenter.router = self
        
        let view = ScanMainViewController(presenter: presenter)
        presenter.view = view
        
        let navigation = NavigationController(rootViewController: view)
        return navigation
    }()
}

extension ScanMainRouterImpl: ScanMainRouter {
    func openResult(devices: [LANDevice]) {
        open(router: ScanResultsRouter(devices: devices))
    }
}
