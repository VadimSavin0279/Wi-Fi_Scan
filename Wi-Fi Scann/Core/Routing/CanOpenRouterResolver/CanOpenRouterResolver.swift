//
//  CanOpenRouterResolver.swift
//  FaxApp
//
//  Created by Eugene on 07.04.2022.
//

import Foundation

enum CanOpenRouterResolverToken {}

protocol CanOpenRouterResolver {
    func canOpen(router: ScreenRouter,
                 from: ScreenRouter) -> Bool
}
