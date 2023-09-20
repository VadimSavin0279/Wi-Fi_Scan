//
//  RoutersCoordinator.swift
//  FaxApp
//
//  Created by Eugene on 19.04.2022.
//

import Foundation

protocol RoutersCoordinator:
    OpenRouterCoordinator,
    CloseRouterCoordinator,
    PopRouterCoordinator {}
