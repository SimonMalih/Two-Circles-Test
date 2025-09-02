/// Represents a football competition or tournament that matches belong to.
/// Provides context for grouping matches and displaying tournament information.
public struct Competition: Decodable, Sendable {
    /// Unique competition identifier
    public let id: Int
    
    /// Competition name for display (e.g., "Premier League", "Champions League")
    public let title: String
    
    public init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
