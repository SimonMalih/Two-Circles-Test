/// Represents a football match with all associated data including teams, venue, and match events.
/// This is the root object containing all match information from kickoff details to final results.
public struct Match: Decodable, Sendable {
    /// Unique identifier for the match
    public let id: Int
    /// Match kickoff information including timestamp and display label
    public let kickoff: Kickoff
    /// Competition/tournament information (optional - some matches may not have competition data)
    public let competition: Competition?
    /// Array of teams participating in the match (typically 2 teams)
    public let teams: [MatchTeam]
    /// Venue information where the match is being played
    public let ground: Ground
    
    /// Current match status with type-safe enum representation
    public let status: MatchStatus
    
    /// Number of spectators attending the match (only available for live/completed matches)
    public let attendance: Int?
    
    /// Current match time information (only available for live/completed matches)
    public let clock: Clock?
    
    /// Array of goal events that occurred during the match (only present when goals have been scored)
    public let goals: [Goal]?
    
    public init(
        id: Int,
        kickoff: Kickoff,
        competition: Competition?,
        teams: [MatchTeam],
        ground: Ground,
        status: MatchStatus,
        attendance: Int?,
        clock: Clock?,
        goals: [Goal]?
    ) {
        self.id = id
        self.kickoff = kickoff
        self.competition = competition
        self.teams = teams
        self.ground = ground
        self.status = status
        self.attendance = attendance
        self.clock = clock
        self.goals = goals
    }
}
