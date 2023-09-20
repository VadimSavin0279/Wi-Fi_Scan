//
//  TabOpenerRouter.swift
//  FaxApp
//
//  Created by Eugene on 25.05.2022.
//

import Foundation
import UIKit

protocol TabOpenerRouter {
    func openTab(_ tab: TabBarType)
}

extension TabOpenerRouter {
    func openTab(_ tab: TabBarType) {
        UIApplication.shared.sceneDelegate?.appCoordinator.tabBar.switchToTab(tab: tab)
    }
}
