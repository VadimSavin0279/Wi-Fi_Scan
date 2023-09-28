//
//  AlterOptionsRouteModel+Factories.swift
//  FaxApp
//
//  Created by Eugene on 5.05.2022.
//

import Foundation
import VisionKit

extension AlertOptionsRouteModel {
    static func moveDevice(toSuspicious: Bool, onSelect: @escaping IClosure<String>) -> AlertOptionsRouteModel {
        var options: [String] = []
        
        if toSuspicious {
            options.append("Move to suspicious")
        } else {
            options.append("Move to trusted")
        }
        
        return .optionsAlert(
            style: .actionSheet,
            title: "L10n.Alerts.Documents.title",
            subtitle: nil,
            options: options,
            onSelect: onSelect,
            onCancel: {}
        )
    }
}
