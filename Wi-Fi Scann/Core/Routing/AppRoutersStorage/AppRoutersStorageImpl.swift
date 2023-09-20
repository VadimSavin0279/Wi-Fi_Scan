//
//  AppRoutersStorageImpl.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import UIKit

final class AppRoutersStorageImpl: AppRoutersStorage {
    
    private(set) var appStructure: [RouterIdentifier: [ScreenRouter]] = [:]
    private let logger: Logger
    
    init(logger: Logger = ConsoleLogger()) {
        self.logger = logger
    }
    
    func push(router: ScreenRouter, in root: RouterIdentifier) {
        appStructure[root] = (appStructure[root] ?? []) + [router]
        logger.log(tabDescription(root: root))
    }
    
    func popRouter(in root: RouterIdentifier) {
        privatePopRouter(in: root)
        
        logger.log(tabDescription(root: root))
    }
    
    func popTo(_ screen: UIViewController, in root: RouterIdentifier) {
        var last = appStructure[root]?.last
        
        while last != nil && last?.screen !== screen {
            privatePopRouter(in: root)
            last = appStructure[root]?.last
        }
        logger.log(tabDescription(root: root))
    }
    
    private func privatePopRouter(in root: RouterIdentifier) {
        guard let _ = appStructure[root]?.last else {
            return
        }
        appStructure[root] = appStructure[root]?.dropLast(1)
    }
    
    private func tabDescription(root: RouterIdentifier) -> String {
        guard let routers = appStructure[root] else { return "Empty tab" }
        var result = ""
        routers.enumerated().forEach { idx, router in
            if idx == 0 {
                result += router.routerIdentifiable.identifier
            } else {
                result += " -> \(router.routerIdentifiable.identifier)"
            }
        }
        return "AppRoutersLog: \(result)"
    }
}
