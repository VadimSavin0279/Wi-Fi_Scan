//
//  ScanResultsOpenRouterResolver.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 28.09.2023.
//

import Foundation

extension CanOpenRouterResolverToken {
    static var scanResultsResolver: CanOpenScreenRouterResolver {
        ScanResultsOpenRouterResolver()
    }
}

fileprivate struct ScanResultsOpenRouterResolver: CanOpenScreenRouterResolver {
    func canOpen(router: ScreenRouter, from: ScreenRouter) -> Bool {
        switch RouterType(indentifiable: router.routerIdentifiable) {
        case .rootTab,
                .guideDescription,
                .scanResults:
            return false
        case .alertOptions:
            return true
        }
    }
}
