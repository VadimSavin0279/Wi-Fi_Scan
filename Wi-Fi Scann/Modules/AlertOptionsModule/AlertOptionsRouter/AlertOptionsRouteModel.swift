//
//  AlertOptionsRouteModel.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import UIKit

struct AlertOptionsRouteModel {
    let style: Style
    let title: String?
    let subtitle: String?
    let options: [String]
    let onSelect: IClosure<String>?
    let onCancel: VoidClosure?
    let onOk: VoidClosure?
    
    init(style: Style,
         title: String?,
         subtitle: String?,
         options: [String],
         onSelect: IClosure<String>?,
         onCancel: VoidClosure?,
         onOk: VoidClosure?) {
        self.style = style
        self.title = title
        self.subtitle = subtitle
        self.options = options
        self.onSelect = onSelect
        self.onCancel = onCancel
        self.onOk = onOk
    }
    
    static func okAlert(
        title: String?,
        subtitle: String?,
        onOk: @escaping VoidClosure
    ) -> AlertOptionsRouteModel {
        AlertOptionsRouteModel(
            style: .alert,
            title: title, subtitle: subtitle,
            options: [],
            onSelect: nil,
            onCancel: nil,
            onOk: onOk
        )
    }
    
    static func okCancelAlert(
        title: String?,
        subtitle: String?,
        onOk: @escaping VoidClosure,
        onCancel: @escaping VoidClosure
    ) -> AlertOptionsRouteModel {
        AlertOptionsRouteModel(
            style: .alert,
            title: title, subtitle: subtitle,
            options: [],
            onSelect: nil,
            onCancel: onCancel,
            onOk: onOk
        )
    }
    
    static func optionsAlert(
        style: Style,
        title: String?,
        subtitle: String?,
        options: [String],
        onSelect: @escaping IClosure<String>,
        onCancel: VoidClosure?
    ) -> AlertOptionsRouteModel {
        AlertOptionsRouteModel(
            style: style,
            title: title, subtitle: subtitle,
            options: options,
            onSelect: onSelect,
            onCancel: onCancel,
            onOk: nil
        )
    }
}

extension AlertOptionsRouteModel {
    enum Style {
        case alert
        case actionSheet
        
        var asNativeStyle: UIAlertController.Style {
            switch self {
            case .alert:
                return .alert
            case .actionSheet:
                return .actionSheet
            }
        }
    }
}
