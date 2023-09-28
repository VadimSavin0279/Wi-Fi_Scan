//
//  Logger.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 16.09.2023.
//

import Foundation

protocol Logger {
    func log(_ text: @autoclosure () -> String)
}

struct ConsoleLogger: Logger {
    func log(_ text: @autoclosure () -> String) {
        #if DEBUG
        print(text())
        #endif
    }
}
