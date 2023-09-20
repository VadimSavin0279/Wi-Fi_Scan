//
//  RoutingInterceptorImpl.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import Foundation

struct RoutingInterceptorImpl: RoutingInterceptor {
    func interceptRoute(from: ScreenRouter, to: ScreenRouter) -> ScreenRouter? {
        let token = RoutingInterceptorToken.self
        let interceptor: RoutingInterceptor
        
        switch RouterType(identifier: to.routerIdentifiable.identifier) {
        default:
            interceptor = token.passThroughRouterInterceptor
        }
        
        let toRouter = interceptor.interceptRoute(from: from, to: to)
        
        return toRouter
    }
}
