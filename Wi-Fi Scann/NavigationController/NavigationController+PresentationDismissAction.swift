//
//  NavigationController+PresentationDismissAction.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import UIKit

extension NavigationController {
    struct PresentationDismissAction {
        let action: Action
        let navController: UINavigationController
        let viewController: UIViewController
    }
}


extension NavigationController.PresentationDismissAction {
    enum Action {
        /// Will Dissmiss modal controller
        case willDismiss
        /// Did dismiss modal controller
        case didDismiss
    }
}
