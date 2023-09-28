//
//  MagneticRouter.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 21.09.2023.
//

import UIKit

final class MagneticRouter: BaseScreenRouter, ScreenRouter {
    var screen: UIViewController { _screen }
    let routerIdentifiable: RouterIdentifiable = RouterType.rootTab(.magnetic)
    let presentationType: ScreenPresentationType = .plain
    
    private lazy var _screen: UIViewController = {
        let presenter = MagneticPresenter()
        let view = MagneticViewController(presenter: presenter)
        presenter.view = view
        
        let navigation = NavigationController(rootViewController: view)
        return navigation
    }()
}

