//
//  CanOpenRouterResolverImpl.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import Foundation

struct CanOpenRouterResolverImpl: CanOpenRouterResolver {
    func canOpen(router: ScreenRouter, from: ScreenRouter) -> Bool {    
        guard !isOpeningRootScreen(router) else {
            assertionFailureDebug("unable to open root screen")
            return false
        }
        
        let token = CanOpenRouterResolverToken.self
        let resolver: CanOpenScreenRouterResolver = {
            switch RouterType(indentifiable: from.routerIdentifiable) {
            case let .rootTab(tabScreenType):
                return tabScreenType.canOpenRouterResolver
            case .scanResults:
                return token.scanResultsResolver
            case .guideDescription, .alertOptions:
                return token.falseAlwaysResolver
            }
        }()
        
        return resolver.canOpen(router: router, from: from)
    }
    
    func isOpeningRootScreen(_ router: ScreenRouter) -> Bool {
        switch RouterType(indentifiable: router.routerIdentifiable) {
        case .rootTab:
            return true
        default:
            return false
        }
    }
}

extension TabBarType {
    fileprivate var canOpenRouterResolver: CanOpenScreenRouterResolver {
        let token = CanOpenRouterResolverToken.self
        switch self {
        case .scanner:
            return token.scanTabResolver
        case .scanHistory:
            return token.historyTabResolver
        case .guide:
            return token.guideTabResolver
        case .magnetic, .settings:
            return token.falseAlwaysResolver
        }
    }
}
