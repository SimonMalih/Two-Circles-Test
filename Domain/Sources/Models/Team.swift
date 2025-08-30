/// Represents a football team with comprehensive identification and naming information.
/// Contains both team-specific and club-level details for flexible display options.
public struct Team: Decodable, Sendable {
    /// Unique team identifier
    public let id: Int
    
    /// Full team name (e.g., "Manchester United", "Arsenal")
    public let name: String
    
    /// Shortened version of team name for compact displays (e.g., "Man Utd", "Arsenal")
    public let shortName: String
    
    /// Team type indicator (typically "FIRST" for first team)
    public let teamType: String
    
    /// Associated club information including abbreviations and alternative names
    public let club: Club
    
    /// Alternative identifiers for external data systems (optional - not all teams have these)
    public let altIds: AltIds?
    
    public init(
        id: Int,
        name: String,
        shortName: String,
        teamType: String,
        club: Club,
        altIds: AltIds?
    ) {
        self.id = id
        self.name = name
        self.shortName = shortName
        self.teamType = teamType
        self.club = club
        self.altIds = altIds
    }
}
