/// Contains match kickoff timing information in both machine-readable and human-readable formats.
/// Provides comprehensive timestamp data for scheduling and display purposes.
public struct Kickoff: Decodable, Sendable {
    /// Data completeness indicator (3 = complete data available)
    public let completeness: Int
    
    /// Kickoff time as Unix timestamp in milliseconds for precise time calculations
    public let millis: Int64
    
    /// Human-readable kickoff time string (e.g., "Mon 25 Nov 2024, 20:00 GMT") for display
    public let label: String
    
    public init(completeness: Int, millis: Int64, label: String) {
        self.completeness = completeness
        self.millis = millis
        self.label = label
    }
}
