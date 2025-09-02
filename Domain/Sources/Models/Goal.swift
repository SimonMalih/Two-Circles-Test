/// Represents a goal event that occurred during a football match.
/// Contains comprehensive information about who scored, when, and how the goal was scored.
public struct Goal: Decodable, Equatable, Sendable {
    /// Unique identifier for the player who scored the goal
    public let personId: Int
    
    /// Unique identifier for the player who provided the assist (optional - not all goals have assists)
    public let assistId: Int?
    
    /// Timing information for when the goal was scored during the match
    public let clock: Clock
    
    /// Match phase when the goal occurred ("1" = first half, "2" = second half)
    public let phase: String
    
    /// Type of goal scored ("G" = regular goal, "P" = penalty goal)
    public let type: String
    
    /// Goal description (typically matches the type: "G" for regular, "P" for penalty)
    public let description: String
    
    public init(
        personId: Int,
        assistId: Int?,
        clock: Clock,
        phase: String,
        type: String,
        description: String
    ) {
        self.personId = personId
        self.assistId = assistId
        self.clock = clock
        self.phase = phase
        self.type = type
        self.description = description
    }
}
