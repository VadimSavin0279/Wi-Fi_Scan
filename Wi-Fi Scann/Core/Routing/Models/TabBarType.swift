//
//  TabBarType.swift
//  FaxApp
//
//  Created by Eugene on 07.04.2022.
//

import Foundation

enum TabBarType: Int, CaseIterable {
    case scanner
    case scanHistory
    case guide
    case magnetic
    case settings
}

extension Set where Element == TabBarType {
    static var allTabs: Set<TabBarType> = Set(TabBarType.allCases)
}

extension TabBarType: Comparable {
    static func < (lhs: TabBarType, rhs: TabBarType) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

extension TabBarType {
    var analyticsIdentifier: String {
        switch self {
        case .scanner:
            return .tabScanner
        case .scanHistory:
            return .tabHistory
        case .guide:
            return .tabGuide
        case .magnetic:
            return .tabMagnetic
        case .settings:
            return .tabSettings
        }
    }
    
    var analyticsIndex: Int {
        (Self.allCases.firstIndex(of: self) ?? 0) + 1
    }
}
