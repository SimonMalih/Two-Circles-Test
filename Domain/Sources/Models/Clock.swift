/// Represents the current match time in both precise and display-friendly formats.
/// Used for showing live match progress and timing information to users.
public struct Clock: Decodable, Equatable, Sendable {
    /// Match time in seconds elapsed since kickoff for precise calculations
    public let secs: Int
    
    /// Human-readable match time string for display (e.g., "50'", "90 +5'00", "02'00")
    /// Formats: Regular time ("50'"), Stoppage time ("90 +5'00"), Early match ("02'00")
    public let label: String
    
    public init(secs: Int, label: String) {
        self.secs = secs
        self.label = label
    }
}
