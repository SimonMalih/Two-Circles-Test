//
//  String+Localization.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 01/09/2025.
//

import Foundation

extension String {
    /// Returns a localized string for the given key
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    /// Returns a localized string with a single parameter substitution
    /// - Parameter parameter: The parameter to substitute
    /// - Returns: Localized string with parameter substituted
    func localizedKey(with parameter: Any) -> String {
        String(format: NSLocalizedString(self, comment: ""), String(describing: parameter))
    }
    
    /// Returns a localized string with multiple parameter substitutions
    /// - Parameter arguments: Variable arguments to substitute
    /// - Returns: Localized string with parameters substituted
    func localizedKey(arguments: Any...) -> String {
        let format = NSLocalizedString(self, comment: "")
        let stringArgs = arguments.map { String(describing: $0) }
        return String(format: format, arguments: stringArgs)
    }
}