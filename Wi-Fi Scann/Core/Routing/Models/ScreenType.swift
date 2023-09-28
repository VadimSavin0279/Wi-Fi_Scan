//
//  ScreenType.swift
//  FaxApp
//
//  Created by Eugene on 07.04.2022.
//

import Foundation

enum RouterType {
    case rootTab(TabBarType)
    case scanResults
    case guideDescription
    case alertOptions
}

extension RouterType: RouterIdentifiable {
    var identifier: String {
        switch self {
        case .rootTab(let tabBarType):
            switch tabBarType {
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
        case .scanResults:
            return .scanResults
        case .guideDescription:
            return .guideDescription
        case .alertOptions:
            return .alertOptions
        }
    }
    
    init(identifier: RouterIdentifier) {
        switch identifier {
        case .tabScanner:
            self = .rootTab(.scanner)
        case .tabHistory:
            self = .rootTab(.scanHistory)
        case .tabGuide:
            self = .rootTab(.guide)
        case .tabMagnetic:
            self = .rootTab(.magnetic)
        case .tabSettings:
            self = .rootTab(.settings)
        case .scanResults:
            self = .scanResults
        case .guideDescription:
            self = .guideDescription
        case .alertOptions:
            self = .alertOptions
        default:
            fatalError()
        }
    }
}

extension String {
    static let tabScanner = "tab_scan"
    static let tabHistory = "tab_history"
    static let tabGuide = "tab_guide"
    static let tabMagnetic = "tab_magnetic"
    static let tabSettings = "tab_settings"
    
    static let scanResults = "scan_results"
    static let guideDescription = "guide_description"
    
    static let alertOptions = "alert_options"
}
