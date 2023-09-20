//
//  BaseScreenRouter.swift
//  FaxApp
//
//  Created by Eugene on 14.04.2022.
//

import Foundation

class BaseScreenRouter {
    weak var coordinator: RoutersCoordinator?
}

extension BaseScreenRouter: RoutersCoordinator {
    func open(router: ScreenRouter,
              animated: Bool) {
        coordinator?.open(router: router,
                          animated: animated)
    }
    
    func closeLast(animated: Bool,
                   completion: VoidClosure?) {
        coordinator?.closeLast(animated: animated,
                               completion: completion)
    }
    
    func lastClosed() {
        coordinator?.lastClosed()
    }
    
    func popTo(router: ScreenRouter,
               animated: Bool,
               completion: VoidClosure?) {
        coordinator?.popTo(router: router,
                           animated: animated,
                           completion: completion)
    }
    
    func popToRoot(animated: Bool) {
        coordinator?.popToRoot(animated: animated)
    }
}
