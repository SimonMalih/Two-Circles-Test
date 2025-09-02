import Foundation

/// Mock implementation of FavouritesRepositoryProtocol for testing purposes
@Observable 
public final class MockFavouritesRepository: FavouritesRepositoryProtocol {
    
    /// Set of favorite club IDs for efficient lookup
    public private(set) var favoriteClubIds: Set<Int>
    
    /// Controls whether operations should simulate failures
    public var shouldFail: Bool = false
    
    /// Error to throw when shouldFail is true
    public enum MockError: Error {
        case simulatedFailure
    }
    
    public init(favoriteClubIds: Set<Int> = []) {
        self.favoriteClubIds = favoriteClubIds
    }
    
    /// Checks if a club is marked as favorite
    /// - Parameter clubId: The club ID to check
    /// - Returns: true if the club is a favorite, false otherwise
    public func isFavorite(clubId: Int) -> Bool {
        favoriteClubIds.contains(clubId)
    }
    
    /// Adds a club to favorites
    /// - Parameter clubId: The club ID to add
    public func addFavorite(clubId: Int) {
        favoriteClubIds.insert(clubId)
    }
    
    /// Removes a club from favorites
    /// - Parameter clubId: The club ID to remove
    public func removeFavorite(clubId: Int) {
        favoriteClubIds.remove(clubId)
    }
    
    /// Toggles favorite status for a club
    /// - Parameter clubId: The club ID to toggle
    public func toggleFavorite(clubId: Int) {
        if favoriteClubIds.contains(clubId) {
            removeFavorite(clubId: clubId)
        } else {
            addFavorite(clubId: clubId)
        }
    }
    
    /// Updates favorites from a collection of club IDs (typically from FavoritesView)
    /// - Parameter clubIds: The new set of favorite club IDs
    public func updateFavorites(_ clubIds: Set<Int>) {
        favoriteClubIds = clubIds
    }
    
    /// Refreshes favorites from storage
    /// Useful for ensuring consistency after external changes
    public func refresh() {
        // Mock implementation - no-op for testing
    }
}

// MARK: - Mock Factory Methods

extension MockFavouritesRepository {
    
    /// Mock repository with some pre-selected favorites
    public static var preview: MockFavouritesRepository {
        MockFavouritesRepository(favoriteClubIds: [1, 10, 12]) // Arsenal, Liverpool, Man Utd
    }
    
    /// Mock repository with no favorites
    public static var empty: MockFavouritesRepository {
        MockFavouritesRepository()
    }
    
    /// Mock repository simulating failure states (for preview purposes)
    public static var failing: MockFavouritesRepository {
        let mock = MockFavouritesRepository()
        mock.shouldFail = true
        return mock
    }
}