//
//  ScanResultsRouter.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 28.09.2023.
//

import UIKit

protocol ScanResultsRouterProtocol: AnyObject {
    func openAllert(toSuspicious: Bool, onSelect: @escaping IClosure<String>)
}

final class ScanResultsRouter: BaseScreenRouter, ScreenRouter {
    var screen: UIViewController { _screen }
    let routerIdentifiable: RouterIdentifiable = RouterType.scanResults
    let presentationType: ScreenPresentationType = .plain
    
    private lazy var _screen: UIViewController = {
        let presenter = ScanResultsPresenter(model: model)
        presenter.router = self
        let view = ScanResultsViewController(presenter: presenter)
        presenter.view = view

        return view
    }()
    
    private let model: [LANDevice]
    
    init(devices: [LANDevice]) {
        model = devices
    }
}

extension ScanResultsRouter: ScanResultsRouterProtocol, AlertOptionsRoutable {
    func openAllert(toSuspicious: Bool, onSelect: @escaping IClosure<String>) {
        openAlertOptions(model: .moveDevice(toSuspicious: toSuspicious,
                                            onSelect: onSelect),
                         animated: true)
    }
}
