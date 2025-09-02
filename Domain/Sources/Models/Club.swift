/// Represents a football club with various naming conventions for different UI contexts.
/// Provides multiple display options from full names to 3-letter abbreviations.
public struct Club: Decodable, Sendable {
    /// Unique club identifier
    public let id: Int
    
    /// Full club name (e.g., "Manchester United", "Arsenal")
    public let name: String
    
    /// 3-letter club abbreviation for very compact displays (e.g., "MUN", "ARS", "LIV")
    public let abbr: String
    
    /// Short version of club name (optional - some clubs may not have a distinct short name)
    public let shortName: String?
    
    public init(id: Int, name: String, abbr: String, shortName: String?) {
        self.id = id
        self.name = name
        self.abbr = abbr
        self.shortName = shortName
    }
}
