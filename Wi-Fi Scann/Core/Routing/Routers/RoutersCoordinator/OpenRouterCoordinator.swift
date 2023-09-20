//
//  OpenRouterCoordinator.swift
//  FaxApp
//
//  Created by Eugene on 14.05.2022.
//

import Foundation

protocol OpenRouterCoordinator: AnyObject {
    func open(router: ScreenRouter, animated: Bool)
}

extension OpenRouterCoordinator {
    func open(router: ScreenRouter, animated: Bool = true) {
        open(router: router, animated: animated)
    }
}
