//
//  ClosureTypeAliases.swift
//  Wi-Fi Scann
//
//  Created by Вадим on 16.09.2023.
//

import Foundation

typealias IClosure<T> = (T) -> Void

typealias OClosure<T> = () -> T

typealias IOClosure<I, O> = (I) -> O

typealias VoidClosure = () -> Void
