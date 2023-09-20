//
//  HistoryTabOpenRouterResolver.swift
//  FaxApp
//
//  Created by Eugene on 12.04.2022.
//

import Foundation

extension CanOpenRouterResolverToken {
    static var historyTabResolver: CanOpenScreenRouterResolver {
        HistoryTabResolver()
    }
}

fileprivate struct HistoryTabResolver: CanOpenScreenRouterResolver {
    func canOpen(router: ScreenRouter, from: ScreenRouter) -> Bool {
        switch RouterType(indentifiable: router.routerIdentifiable) {
        case .rootTab,
                .guideDescription:
            return false
        case .scanResults:
            return true
        }
    }
}
