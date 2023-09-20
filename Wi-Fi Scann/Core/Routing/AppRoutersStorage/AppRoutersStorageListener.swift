//
//  AppRoutersStorageListener.swift
//  FaxApp
//
//  Created by Eugene on 19.05.2022.
//

import Combine

protocol AppRoutersStorageListener {
    var push: PassthroughSubject<ScreenRouter, Never> { get }
    var dismiss: PassthroughSubject<ScreenRouter, Never> { get }
}

