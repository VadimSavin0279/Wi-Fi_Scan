//
//  CanOpenScreenRouterResolver.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import Foundation

protocol CanOpenScreenRouterResolver {
    func canOpen(router: ScreenRouter, from: ScreenRouter) -> Bool
}
