//
//  FaxTabOpenRouterResolver.swift
//  FaxApp
//
//  Created by Eugene on 12.04.2022.
//

import Foundation

extension CanOpenRouterResolverToken {
    static var scanTabResolver: CanOpenScreenRouterResolver {
        ScannerTabOpenRouterResolver()
    }
}

fileprivate struct ScannerTabOpenRouterResolver: CanOpenScreenRouterResolver {
    func canOpen(router: ScreenRouter, from: ScreenRouter) -> Bool {
        switch RouterType(indentifiable: router.routerIdentifiable) {
        case .rootTab,
                .guideDescription,
                .alertOptions:
            return false
        case .scanResults:
            return true
        }
    }
}
