//
//  NavigationController+PopNavigationAction.swift
//  FaxApp
//
//  Created by Eugene on 4.05.2022.
//

import UIKit

extension NavigationController {
    struct PopNavigationAction {
        let action: Action
        let navController: UINavigationController
        let viewController: UIViewController
    }
}


extension NavigationController.PopNavigationAction {
    enum Action {
        /// Will pop plain controller
        case pop
        /// Will pop to plain controller
        case popTo
    }
}
