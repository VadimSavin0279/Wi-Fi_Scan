//
//  CloseRouterCoordinator.swift
//  FaxApp
//
//  Created by Eugene on 14.05.2022.
//

import Foundation

protocol CloseRouterCoordinator: AnyObject {
    func closeLast(animated: Bool, completion: VoidClosure?)
    
    func lastClosed()
}

extension CloseRouterCoordinator {
    func closeLast(animated: Bool = false, completion: VoidClosure? = nil) {
        closeLast(animated: animated, completion: completion)
    }
}
