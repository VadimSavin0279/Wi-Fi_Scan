//
//  RouterIdentifiable.swift
//  FaxApp
//
//  Created by Eugene on 14.05.2022.
//

import Foundation

typealias RouterIdentifier = String

protocol RouterIdentifiable {
    var identifier: RouterIdentifier { get }
    
    init(identifier: RouterIdentifier)
}

extension RouterIdentifiable {
    init(indentifiable: RouterIdentifiable) {
        self.init(identifier: indentifiable.identifier)
    }
}
