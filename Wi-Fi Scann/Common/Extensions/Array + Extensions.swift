//
//  Array + Extensions.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 28.09.2023.
//

import Foundation

extension Array<LANDevice> {
    func contains(device: LANDevice) -> Bool {
        for element in self {
            if element.ipAddress == device.ipAddress {
                return true
            }
        }
        return false
    }
}
