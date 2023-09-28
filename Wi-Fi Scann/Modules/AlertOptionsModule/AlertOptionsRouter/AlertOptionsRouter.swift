//
//  AlertOptionsRouter.swift
//  FaxApp
//
//  Created by Eugene on 14.04.2022.
//

import UIKit

final class AlertOptionsRouter: BaseScreenRouter, ScreenRouter {
    
    var screen: UIViewController { _screen }
    let routerIdentifiable: RouterIdentifiable = RouterType.alertOptions
    let presentationType: ScreenPresentationType = .modal

    private lazy var _screen: UIViewController = {
        let model = modifiedModel
        let actionController = AlertOptionsViewController(
            title: model.title,
            message: model.subtitle,
            preferredStyle: model.style.asNativeStyle
        )
        
        actionController.router = self
        
        if model.onCancel != nil && model.style == .alert {
            let cancelAction = UIAlertAction(
                title: "",
                style: .default,
                handler: { [model] _ in
                    model.onCancel?()
                }
            )
            actionController.addAction(cancelAction)
        }
        
        model.options.forEach { item in
            let action = UIAlertAction(
                title: item,
                style: .default,
                handler: { [model] _ in
                    model.onSelect?(item)
                }
            )
            
            actionController.addAction(action)
        }
        
        if model.onCancel != nil && model.style == .actionSheet {
            let cancelAction = UIAlertAction(
                title: "L10n.Alerts.Sending.Push.cancel",
                style: .cancel,
                handler: { [model] _ in
                    model.onCancel?()
                }
            )
            actionController.addAction(cancelAction)
        }
        
        if model.onOk != nil {
            let cancelAction = UIAlertAction(
                title: "Ok",
                style: .default,
                handler: { [model] _ in
                    model.onOk?()
                }
            )
            actionController.addAction(cancelAction)
        }
        
        return actionController
    }()
    
    private let originModel: AlertOptionsRouteModel
    private var modifiedModel: AlertOptionsRouteModel {
        let onOk: VoidClosure? = {
            guard let onOk = originModel.onOk else {
                return nil
            }
            return { [weak self] in
                self?.lastClosed()
                onOk()
            }
        }()
        
        let onCancel: VoidClosure? = {
            guard let onCancel = originModel.onCancel else {
                return nil
            }
            return { [weak self] in
                self?.lastClosed()
                onCancel()
            }
        }()
        
        let onOptionSelect: IClosure<String>? = {
            guard let onOptionSelect = originModel.onSelect else {
                return nil
            }
            return { [weak self] option in
                self?.lastClosed()
                onOptionSelect(option)
            }
        }()
        
        return AlertOptionsRouteModel(
            style: originModel.style,
            title: originModel.title,
            subtitle: originModel.subtitle,
            options: originModel.options,
            onSelect: onOptionSelect,
            onCancel: onCancel,
            onOk: onOk
        )
    }
    
    init(model: AlertOptionsRouteModel) {
        self.originModel = model
    }
}
