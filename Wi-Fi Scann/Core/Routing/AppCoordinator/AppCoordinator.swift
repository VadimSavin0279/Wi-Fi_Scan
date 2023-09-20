//
//  AppCoordinator.swift
//  FaxApp
//
//  Created by Eugene on 07.04.2022.
//

import UIKit
import Combine

final class AppCoordinator:
    TabOpenerRouter,
    RoutersCoordinator,
    AppRoutersStructureProvider,
    RootRoutersConfigurable {
    
    let tabBar = TabBarController(items: TabBarType.allCases)
    
    var appStructure: [RouterIdentifier: [ScreenRouter]] {
        routersStorage.appStructure
    }
    
    private var cancelBag = Set<AnyCancellable>()
    private let isAnimationsEnabled: Bool
    private let routersStorage: AppRoutersStorage
    private let canOpenRouterResolver: CanOpenRouterResolver
    private let routingInterceptor: RoutingInterceptor
    
    init(isAnimationsEnabled: Bool = true,
         routersStorage: AppRoutersStorage,
         canOpenRouterResolver: CanOpenRouterResolver = CanOpenRouterResolverImpl(),
         routingInterceptor: RoutingInterceptor = RoutingInterceptorImpl()) {
        self.routersStorage = routersStorage
        self.isAnimationsEnabled = isAnimationsEnabled
        self.canOpenRouterResolver = canOpenRouterResolver
        self.routingInterceptor = routingInterceptor
    }
    
    func configure(routers: [ScreenRouter]) {
        self.tabBar.viewControllers = routers.map {
            $0.coordinator = self
            guard let navController = $0.screen as? NavigationController else {
                assertionFailureDebug("unexpected")
                return $0.screen
            }
            routersStorage.push(router: $0, in: $0.routerIdentifiable.identifier)
            subscribeOnDismissActions(navController)
            return navController
        }
    }
    
    func openTab(_ tab: TabBarType) {
        tabBar.switchToTab(tab: tab)
    }
    
    func open(router: ScreenRouter, animated: Bool) {
        guard let model = routerOpeningModel(routerToOpen: router) else {
            return
        }
        if model.routersOffset != 0 {
            print(model.routersOffset)
        }
        guard let interceptedRouter = routingInterceptor.interceptRoute(from: model.handlingRouter, to: router) else {
            return
        }
        
        guard let model = routerOpeningModel(routerToOpen: interceptedRouter) else {
            return
        }
        
        defer {
            routersStorage.push(router: interceptedRouter, in: model.rootIdentifier)
        }
        
        interceptedRouter.coordinator = self
        switchToTabIfNeeded(index: model.tabIndex)
        
        if model.routersOffset == 0 {
            navigateOpen(router: interceptedRouter, in: model.rootIdentifier, animated: animated)
            return
        }
        
        navigatePop(to: model.handlingRouter, in: model.rootIdentifier, completion: { [weak self] in
            self?.navigateOpen(router: interceptedRouter, in: model.rootIdentifier, animated: animated)
        })
    }
    
    func closeLast(animated: Bool, completion: VoidClosure?) {
        guard let activeTabRootIdentifier = activeTabRootIdentifier() else {
            return
        }
        
        let routers = (appStructure[activeTabRootIdentifier] ?? [])
        guard routers.count >= 2 else {
            assertionFailureDebug("unable to close root router in tab\(activeTabRootIdentifier)")
            return
        }
        
        navigatePop(to: routers[routers.count - 2],
                    in: activeTabRootIdentifier,
                    completion: completion)
    }
    
    func lastClosed() {
        guard let activeTabRootIdentifier = activeTabRootIdentifier() else {
            return
        }
        routersStorage.popRouter(in: activeTabRootIdentifier)
    }
    
    func popTo(router: ScreenRouter, animated: Bool, completion: VoidClosure?) {
        guard let activeTabRootIdentifier = activeTabRootIdentifier() else {
            return
        }
        
        navigatePop(to: router, in: activeTabRootIdentifier, completion: completion)
    }
    
    func popToRoot(animated: Bool) {
        guard let activeTabRootIdentifier = activeTabRootIdentifier(),
              let navController = lastNavController(in: activeTabRootIdentifier)
        else {
            return
        }
        
        let animated = isAnimated(animated)
        let viewControllers = navController.popToRootViewController(animated: animated)
        animatedCompletion(animated, completion: { [weak self] in
            viewControllers?.forEach { _ in
                self?.routersStorage.popRouter(in: activeTabRootIdentifier)
            }
        })
    }
    
    // MARK: - Private methods
    
    private typealias RouterOpeningModel = (
        tabIndex: Int,
        rootIdentifier: RouterIdentifier,
        routersOffset: Int,
        handlingRouter: ScreenRouter
    )
    private func routerOpeningModel(routerToOpen: ScreenRouter) -> RouterOpeningModel? {
        var tabRootIdentifiers = tabRootIdentifiers().sorted(by: { $0.key < $1.key })
        
        guard tabRootIdentifiers.count == tabBar.viewControllers?.count else {
            assertionFailureDebug("unexpected behaviour")
            return nil
        }
        
        func model(_ tabIndentifier: Dictionary<Int, StringIdentifier>.Element) -> RouterOpeningModel? {
            var result: RouterOpeningModel?
            for (idx, value) in (appStructure[tabIndentifier.value] ?? []).reversed().enumerated() {
                if canOpenRouterResolver.canOpen(router: routerToOpen, from: value) {
                    result = RouterOpeningModel(tabIndentifier.key, tabIndentifier.value, idx, value)
                    break
                }
            }
            return result
        }
        
        let activeTabRootIdentifier = tabRootIdentifiers.remove(at: tabBar.selectedIndex)
        if let model = model(activeTabRootIdentifier) {
            return model
        }
        
        return tabRootIdentifiers.lazy.compactMap { model($0) }.first
    }
    
    private func switchToTabIfNeeded(index: Int) {
        guard let actualTab = TabBarType(rawValue: index),
              tabBar.currentTab != actualTab
        else {
            return
        }
        
        tabBar.switchToTab(tab: actualTab)
    }
    
    private func navigateOpen(router: ScreenRouter,
                              in rootIdentifier: StringIdentifier,
                              animated: Bool) {
        guard let navController = lastNavController(in: rootIdentifier) else {
            return
        }
        let animated = isAnimated(animated)
        router.coordinator = self
        switch router.presentationType {
        case .plain:
            navController.pushViewController(router.screen, animated: animated)
        case .modal:
            if let navController = router.screen as? NavigationController {
                subscribeOnDismissActions(navController)
            }
            let routers = (routersStorage.appStructure[rootIdentifier] ?? [])
            routers.last?.screen.present(router.screen, animated: animated)
        }
    }
    
    private func navigatePop(to router: ScreenRouter,
                             in rootIdentifier: RouterIdentifier,
                             animated: Bool = true,
                             completion: VoidClosure?) {
        let routers = (routersStorage.appStructure[rootIdentifier] ?? [])
        let last = routers[routers.count - 1]
        guard routers.last?.screen !== router.screen else { return }
        
        let animated = isAnimated(animated)
        let navController = lastNavController(in: rootIdentifier)
        
        switch last.presentationType {
        case .plain:
            if let _ = router.screen as? UINavigationController {
                popToRoot(animated: true)
            } else {
                navController?.popToViewController(router.screen, animated: animated)
            }
            animatedCompletion(animated, completion: completion)
        case .modal:
            // sometimes Dismiss Actions not triggered
            // for example when tap cancel in contacts picker screen, so we check window
            let animated = last.screen.view.window == nil ? false : animated
            let shouldPopAfterDismiss = routers[routers.count - 2].screen !== router.screen
            
            last.screen.dismiss(animated: animated) { [weak self] in
                guard shouldPopAfterDismiss else {
                    self?.animatedCompletion(animated, completion: completion)
                    return
                }
                navController?.popToViewController(router.screen, animated: animated)
                self?.animatedCompletion(animated, completion: completion)
            }
        }
    }
    
    func subscribeOnDismissActions(_ navController: NavigationController)  {
        navController
            .modalDismissActionPublisher
            .sink(receiveValue: { [weak self] action in
                guard let self = self else { return }
                switch action.action {
                case .willDismiss:
                    break
                case .didDismiss:
                    self.rootIdentifier(for: action.navController).flatMap {
                        self.routersStorage.popRouter(in: $0)
                    }
                }
            })
            .store(in: &cancelBag)
        
        navController
            .popActionPublisher
            .sink(receiveValue: { [weak self] action in
                guard let self = self else { return }
                let rootIdentifier = self.rootIdentifier(for: action.navController)
                switch action.action {
                case .pop:
                    rootIdentifier.flatMap {
                        self.routersStorage.popRouter(in: $0)
                    }
                case .popTo:
                    rootIdentifier.flatMap {
                        self.routersStorage.popTo(action.viewController, in: $0)
                    }
                }
            })
            .store(in: &cancelBag)
        
        let willDismiss = navController
            .presentationDismissActionPublisher
            .filter { $0.action == .willDismiss }
            .map { [weak self] in self?.rootIdentifier(for: $0.navController) }
            .eraseToAnyPublisher()
        let didDismiss = navController
            .presentationDismissActionPublisher
            .filter { $0.action == .didDismiss }
            .eraseToAnyPublisher()
        
        Publishers.CombineLatest(willDismiss, didDismiss)
            .sinkSuccess { [weak self] params in
                guard let self = self,
                      let rootIdentifier = params.0,
                      let index = self.appStructure[rootIdentifier]?.firstIndex(where: {
                          $0.screen == params.1.viewController
                      })
                else {
                    assertionFailureDebug("unexpected")
                    return
                }
                
                let router = (self.appStructure[rootIdentifier] ?? [])[index - 1]
                self.routersStorage.popTo(router.screen, in: rootIdentifier)
            }.store(in: &cancelBag)
    }
    
    private func tabRootIdentifiers() -> [Int: StringIdentifier] {
        var result: [Int: StringIdentifier] = [:]
        for rootRouter in routersStorage.rootRouters {
            if let rootNav = appStructure[rootRouter.routerIdentifiable.identifier]?.first?.screen as? NavigationController,
               let tabIndex = tabBar.viewControllers?.firstIndex(where: { $0 === rootNav }) {
                result[tabIndex] = rootRouter.routerIdentifiable.identifier
            }
        }
        return result
    }
    
    private func rootIdentifier(for navController: UINavigationController) -> StringIdentifier? {
        return appStructure.first(where: { _, routers in
            var result = false
            for router in routers.reversed() {
                let routerNav = (router.screen as? UINavigationController)
                ?? router.screen.navigationController
                result = navController === routerNav
                if result { break }
            }
            return result
        })?.key
    }
    
    private func lastNavController(in rootIdentifier: StringIdentifier) -> UINavigationController? {
        var nav: UINavigationController?
        for router in (appStructure[rootIdentifier] ?? []).reversed() {
            nav = (router.screen as? UINavigationController) ?? router.screen.navigationController
            if nav != nil {
                break
            }
        }
        return nav
    }
    
    private func activeTabRootIdentifier() -> StringIdentifier? {
        tabRootIdentifiers()[tabBar.selectedIndex]
    }
    
    /// Return animated flag depends on animations allowance. It needs for tests to handle everything without animations.
    private func isAnimated(_ animated: Bool) -> Bool {
        isAnimationsEnabled ? animated : false
    }
    
    private func animatedCompletion(_ animated: Bool, completion: VoidClosure?) {
        if animated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.17) {
                completion?()
            }
        } else {
            completion?()
        }
    }
}
