//
//  AlertOptionsRoutable.swift
//  FaxApp
//
//  Created by Eugene on 5.05.2022.
//

import Foundation

protocol AlertOptionsRoutable: CloseRouterCoordinator {
    func openAlertOptions(model: AlertOptionsRouteModel, animated: Bool)
}

extension AlertOptionsRoutable where Self: ScreenRouter  {
    func openAlertOptions(model: AlertOptionsRouteModel, animated: Bool) {
        let router = AlertOptionsRouter(model: model)
        open(router: router, animated: animated)
    }
}
