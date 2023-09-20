//
//  AppRoutersStructureProvider.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import Foundation

protocol AppRoutersStructureProvider {
    var appStructure: [RouterIdentifier: [ScreenRouter]] { get }
}

extension AppRoutersStructureProvider {
    var rootRouters: [ScreenRouter] {
        var result: [ScreenRouter] = []
        appStructure.forEach { _, routers in
            routers[safe: 0].flatMap {
                result.append($0)
            }
        }
        return result
    }
}
