//
//  Int+FormattedAttendance.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 01/09/2025.
//

import Foundation

extension Int {
    /// Formats this integer into a human-readable attendance string.
    ///
    /// Converts this integer representing an attendance count into a formatted string
    /// using decimal number formatting with appropriate thousands separators.
    ///
    /// - Returns: A string representing the formatted attendance (e.g., "45,000").
    var formattedAttendance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}