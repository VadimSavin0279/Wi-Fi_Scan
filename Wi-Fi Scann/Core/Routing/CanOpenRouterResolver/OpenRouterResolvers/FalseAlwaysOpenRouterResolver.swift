//
//  FalseAlwaysOpenRouterResolver.swift
//  FaxApp
//
//  Created by Eugene on 14.04.2022.
//

import Foundation

extension CanOpenRouterResolverToken {
    static var falseAlwaysResolver: CanOpenScreenRouterResolver {
        FalseAlwaysResolver()
    }
}

fileprivate struct FalseAlwaysResolver: CanOpenScreenRouterResolver {
    func canOpen(router: ScreenRouter, from: ScreenRouter) -> Bool {
        false
    }
}
