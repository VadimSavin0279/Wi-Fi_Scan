//
//  SettingsRouter.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 21.09.2023.
//

import UIKit

final class SettingsRouter: BaseScreenRouter, ScreenRouter {
    var screen: UIViewController { _screen }
    let routerIdentifiable: RouterIdentifiable = RouterType.rootTab(.settings)
    let presentationType: ScreenPresentationType = .plain
    
    private lazy var _screen: UIViewController = {
        let view = SettingsViewController()
        
        let navigation = NavigationController(rootViewController: view)
        navigation.isNavigationBarHidden = true
        return navigation
    }()
}

