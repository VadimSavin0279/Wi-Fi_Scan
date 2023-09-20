//
//  RoutingInterceptor.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import Foundation

enum RoutingInterceptorToken {}

protocol RoutingInterceptor {
    func interceptRoute(from: ScreenRouter, to: ScreenRouter) -> ScreenRouter?
}
