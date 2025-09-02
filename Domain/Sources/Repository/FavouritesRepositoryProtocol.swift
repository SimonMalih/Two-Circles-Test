import Foundation

/// Protocol for managing favourite clubs with real-time updates.
/// Provides a contract for favourite state management across the app.
public protocol FavouritesRepositoryProtocol: Observable, Sendable {
    
    /// Set of favorite club IDs for efficient lookup
    var favoriteClubIds: Set<Int> { get }
    
    /// Checks if a club is marked as favorite
    /// - Parameter clubId: The club ID to check
    /// - Returns: true if the club is a favorite, false otherwise
    func isFavorite(clubId: Int) -> Bool
    
    /// Adds a club to favorites
    /// - Parameter clubId: The club ID to add
    func addFavorite(clubId: Int)
    
    /// Removes a club from favorites
    /// - Parameter clubId: The club ID to remove
    func removeFavorite(clubId: Int)
    
    /// Toggles favorite status for a club
    /// - Parameter clubId: The club ID to toggle
    func toggleFavorite(clubId: Int)
    
    /// Updates favorites from a collection of club IDs (typically from FavoritesView)
    /// - Parameter clubIds: The new set of favorite club IDs
    func updateFavorites(_ clubIds: Set<Int>)
    
    /// Refreshes favorites from storage
    /// Useful for ensuring consistency after external changes
    func refresh()
}