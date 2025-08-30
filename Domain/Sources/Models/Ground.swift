/// Represents the venue where a football match is being played.
/// Contains comprehensive location and identification information for the stadium or ground.
public struct Ground: Decodable, Sendable {
    /// Unique venue identifier
    public let id: Int
    
    /// Stadium or ground name (e.g., "Emirates Stadium", "Old Trafford", "Anfield")
    public let name: String
    
    /// City where the venue is located (e.g., "London", "Manchester", "Liverpool")
    public let city: String
    
    /// Data source indicator (typically "OPTA" for Opta Sports data)
    public let source: String
    
    public init(id: Int, name: String, city: String, source: String) {
        self.id = id
        self.name = name
        self.city = city
        self.source = source
    }
}
