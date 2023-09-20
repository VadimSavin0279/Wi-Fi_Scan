//
//  PassThroughRouterInterceptor.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import Foundation

extension RoutingInterceptorToken {
    static var passThroughRouterInterceptor: RoutingInterceptor {
        PassThroughRouterInterceptor()
    }
}

fileprivate struct PassThroughRouterInterceptor: RoutingInterceptor {
    func interceptRoute(from: ScreenRouter, to: ScreenRouter) -> ScreenRouter? {
        to
    }
}
