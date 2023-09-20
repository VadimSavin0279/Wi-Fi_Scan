//
//  PopRouterCoordinator.swift
//  FaxApp
//
//  Created by Eugene on 14.05.2022.
//

import Foundation

protocol PopRouterCoordinator: AnyObject {
    func popTo(router: ScreenRouter,
               animated: Bool,
               completion: VoidClosure?)
    
    func popToRoot(animated: Bool)
}

extension PopRouterCoordinator {
    func popTo(router: ScreenRouter,
               animated: Bool = true,
               completion: VoidClosure? = nil) {
        popTo(router: router,
              animated: animated,
              completion: completion)
    }
}


