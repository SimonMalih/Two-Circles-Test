/// Represents the current status of a football match with clear semantic meaning.
/// Provides type-safe status handling for match display and business logic.
public enum MatchStatus: String, Decodable, Sendable, CaseIterable {
    /// Match has not started yet
    case upcoming = "U"
    
    /// Match is currently being played
    case inProgress = "I"
    
    /// Match has finished
    case completed = "C"
    
    /// Human-readable description of the match status for debugging and logging
    public var description: String {
        switch self {
        case .upcoming:
            "Upcoming"
        case .inProgress:
            "In Progress"
        case .completed:
            "Completed"
        }
    }
    
    public var isLive: Bool {
        self == .inProgress
    }
    
    public var isFinished: Bool {
        self == .completed
    }
    
    public var shouldShowScores: Bool {
        self == .inProgress || self == .completed
    }
}
