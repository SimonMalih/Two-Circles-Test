/// Contains alternative identifiers for external data provider systems.
/// Used for cross-referencing teams across different sports data platforms.
public struct AltIds: Decodable, Sendable {
    /// Opta Sports data provider identifier (e.g., "t1", "t3", "t14") - not all teams have this identifier
    public let opta: String?
    
    public init(opta: String?) {
        self.opta = opta
    }
}
