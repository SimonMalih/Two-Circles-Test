import Foundation

/// Protocol for fetching match data
public protocol MatchService: Sendable {
    /// Fetches all matches from the data source
    /// - Returns: Array of Match objects
    /// - Throws: Any errors that occur during data fetching
    func fetchMatches() async throws -> [Match]
}