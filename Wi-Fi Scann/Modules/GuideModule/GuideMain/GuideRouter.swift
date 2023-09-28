//
//  GuideRouter.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 21.09.2023.
//

import UIKit

protocol GuideRouterProtocol {
    func openGuideDetail(with model: [GuideDetailCellModel], title: String)
}

final class GuideRouter: BaseScreenRouter, ScreenRouter {
    var screen: UIViewController { _screen }
    let routerIdentifiable: RouterIdentifiable = RouterType.rootTab(.guide)
    let presentationType: ScreenPresentationType = .plain
    
    private lazy var _screen: UIViewController = {
        let presenter = GuidePresenter(router: self)
        let view = GuideViewController(presenter: presenter)
        presenter.view = view
        
        let navigation = NavigationController(rootViewController: view)
        return navigation
    }()
}

extension GuideRouter: GuideRouterProtocol {
    func openGuideDetail(with model: [GuideDetailCellModel], title: String) {
        open(router: GuideDetailRouter(model: model, title: title))
    }
}
