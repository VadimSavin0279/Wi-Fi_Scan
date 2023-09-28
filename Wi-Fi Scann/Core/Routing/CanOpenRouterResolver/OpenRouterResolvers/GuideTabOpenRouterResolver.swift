//
//  SettingsTabOpenRouterResolver.swift
//  FaxApp
//
//  Created by Eugene on 12.04.2022.
//

import Foundation

extension CanOpenRouterResolverToken {
    static var guideTabResolver: CanOpenScreenRouterResolver {
        GuideTabResolver()
    }
}

fileprivate struct GuideTabResolver: CanOpenScreenRouterResolver {
    func canOpen(router: ScreenRouter, from: ScreenRouter) -> Bool {
        switch RouterType(indentifiable: router.routerIdentifiable) {
        case .rootTab,
                .scanResults,
                .alertOptions:
            return false
        case .guideDescription:
            return true
        }
    }
}
