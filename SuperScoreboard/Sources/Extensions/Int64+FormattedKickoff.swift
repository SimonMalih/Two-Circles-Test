//
//  Int64+FormattedKickoff.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import Foundation

extension Int64 {
    /// Formats this Unix timestamp in milliseconds into a kickoff time string.
    ///
    /// Converts this 64-bit integer representing the number of milliseconds
    /// since the Unix epoch into a human-readable time string in the "HH:mm" format.
    ///
    /// - Returns: A string representing the formatted kickoff time (e.g., "20:00").
    var formattedKickoffTime: String {
        let date = Date(timeIntervalSince1970: Double(self) / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
