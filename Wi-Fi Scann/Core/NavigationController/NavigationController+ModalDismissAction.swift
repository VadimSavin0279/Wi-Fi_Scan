//
//  NavigationController+ModalDismissAction.swift
//  FaxApp
//
//  Created by Eugene on 14.06.2022.
//

import UIKit

extension NavigationController {
    struct ModalDismissAction {
        let action: Action
        let navController: UINavigationController
        let viewController: UIViewController
    }
}

extension NavigationController.ModalDismissAction {
    enum Action {
        /// Will Dissmiss modal controller
        case willDismiss
        /// Did dismiss modal controller
        case didDismiss
    }
}
