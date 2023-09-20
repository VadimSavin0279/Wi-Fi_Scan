//
//  AppRoutersStorage.swift
//  FaxApp
//
//  Created by Eugene on 14.05.2022.
//

import UIKit

protocol AppRoutersStorage: AppRoutersStructureProvider {
    func push(router: ScreenRouter, in root: RouterIdentifier)
    func popRouter(in root: RouterIdentifier)
    func popTo(_ screen: UIViewController, in root: RouterIdentifier)
}
