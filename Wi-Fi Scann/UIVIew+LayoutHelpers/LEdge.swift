//
//  LEdge.swift
//  FaxApp
//
//  Created by Eugene on 07.04.2022.
//

import Foundation

public enum LEdge {
    case left
    case top
    case right
    case bottom
    
    var axis: LAxis {
        switch self {
        case .left, .right:
            return .x
        case .top, .bottom:
            return .y
        }
    }
}
