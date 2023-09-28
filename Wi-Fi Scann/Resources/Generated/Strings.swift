// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Guide {
    /// Guide
    internal static let title = L10n.tr("Localizable", "guide.title", fallback: "Guide")
  }
  internal enum Magnetic {
    /// Detect
    internal static let detect = L10n.tr("Localizable", "magnetic.detect", fallback: "Detect")
    /// Stop
    internal static let stop = L10n.tr("Localizable", "magnetic.stop", fallback: "Stop")
    /// Hidden Camera might be have strong magnetic field.
    internal static let tip = L10n.tr("Localizable", "magnetic.tip", fallback: "Hidden Camera might be have strong magnetic field.")
    /// Magnetic detect
    internal static let title = L10n.tr("Localizable", "magnetic.title", fallback: "Magnetic detect")
  }
  internal enum ScanMain {
    /// Suspicious device found: 
    internal static let deviceFound = L10n.tr("Localizable", "scanMain.deviceFound", fallback: "Suspicious device found: ")
    /// Recheck
    internal static let recheck = L10n.tr("Localizable", "scanMain.recheck", fallback: "Recheck")
    /// View Results
    internal static let results = L10n.tr("Localizable", "scanMain.results", fallback: "View Results")
    /// Start
    internal static let start = L10n.tr("Localizable", "scanMain.start", fallback: "Start")
    /// Router MAC: 
    internal static let wiFiIP = L10n.tr("Localizable", "scanMain.WiFiIP", fallback: "Router MAC: ")
    internal enum ProgressBar {
      /// Checking...
      internal static let checking = L10n.tr("Localizable", "scanMain.progressBar.checking", fallback: "Checking...")
    }
  }
  internal enum TabBar {
    /// Guide
    internal static let guide = L10n.tr("Localizable", "tabBar.guide", fallback: "Guide")
    /// History
    internal static let history = L10n.tr("Localizable", "tabBar.history", fallback: "History")
    /// Magnetic
    internal static let magnetic = L10n.tr("Localizable", "tabBar.magnetic", fallback: "Magnetic")
    /// Scanner
    internal static let scanner = L10n.tr("Localizable", "tabBar.scanner", fallback: "Scanner")
    /// Settings
    internal static let settings = L10n.tr("Localizable", "tabBar.settings", fallback: "Settings")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
