//
//  SafeExtension.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 16.09.2023.
//

import Foundation

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
