/// Represents a team's participation in a specific match, including their current score.
/// This wrapper combines team information with match-specific data like the current score.
public struct MatchTeam: Decodable, Sendable {
    /// Detailed team information including name, club details, and identifiers
    public let team: Team
    
    /// Current or final score for this team (only present for live/completed matches)
    public let score: Int?
    
    public init(team: Team, score: Int?) {
        self.team = team
        self.score = score
    }
}
