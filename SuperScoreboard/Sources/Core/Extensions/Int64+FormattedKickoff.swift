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
    
    // MARK: - Mock Timestamps
    
    /// Mon 31 Dec 2024, 18:00 GMT
    static let completedMatchKickoff: Int64 = 1735653600000
    
    /// Mon 31 Dec 2024, 19:00 GMT
    static let liveMatchKickoff: Int64 = 1735657200000
    
    /// Mon 31 Dec 2024, 20:00 GMT
    static let upcomingMatchKickoff: Int64 = 1735660800000
}
