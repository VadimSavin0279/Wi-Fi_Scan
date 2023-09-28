//
//  ScanningHistoryRouter.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 21.09.2023.
//

import UIKit

final class ScanningHistoryRouter: BaseScreenRouter, ScreenRouter {
    var screen: UIViewController { _screen }
    let routerIdentifiable: RouterIdentifiable = RouterType.rootTab(.scanHistory)
    let presentationType: ScreenPresentationType = .plain
    
    private lazy var _screen: UIViewController = {
        let view = ScanningHistoryViewController()
        
        let navigation = NavigationController(rootViewController: view)
        return navigation
    }()
}
