//
//  AssertDebug.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 16.09.2023.
//

import Foundation

func assertionFailureDebug(_ message: @autoclosure () -> String = String(),
                           file: StaticString = #file,
                           line: UInt = #line) {
    #if DEBUG
    assertionFailure(message(), file: file, line: line)
    #endif
}
