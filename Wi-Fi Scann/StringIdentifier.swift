//
//  StringIdentifier.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 16.09.2023.
//

import UIKit

typealias StringIdentifier = String

protocol StaticStringIdentifiable {
    static var identifier: StringIdentifier { get }
}

extension UIView: StaticStringIdentifiable {
    static var identifier: StringIdentifier {
        String(describing: self)
    }
}
