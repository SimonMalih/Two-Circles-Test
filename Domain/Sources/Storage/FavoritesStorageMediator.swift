import Foundation
import Core

/// A simple storage mediator for favorite club IDs.
///
/// `FavoritesStorageMediator` provides three essential operations for managing favorites:
/// - Save: Overwrites the entire favorites list
/// - Fetch: Retrieves the current favorites list
/// - Clear: Removes all favorites
///
/// All business logic (toggle, add/remove, checking status) is handled by the ViewModel layer.
///
/// # Usage Examples
/// ```swift
/// let storage = UserDefaultsStorageAPI()
/// let mediator = FavoritesStorageMediator(storageAPI: storage)
///
/// // Save favorites (overwrites existing)
/// try mediator.saveFavorites([1, 2, 3])
///
/// // Fetch current favorites
/// let favorites = try mediator.fetchFavorites()
///
/// // Clear all favorites
/// try mediator.clearAllFavorites()
/// ```
public final class FavoritesStorageMediator: Sendable {
    
    private let storageAPI: StorageAPI
    private let favoritesKey = "favorite_club_ids"
    
    /// Initializes the mediator with a storage API implementation.
    ///
    /// - Parameter storageAPI: The storage API to use for persistence operations
    public init(storageAPI: StorageAPI) {
        self.storageAPI = storageAPI
    }
    
    /// Saves an array of favorite club IDs to storage, overwriting any existing favorites.
    ///
    /// - Parameter favoriteIds: Array of club IDs to save as favorites
    /// - Throws: `FavoritesStorageError` if the operation fails
    public func saveFavorites(_ favoriteIds: [Int]) throws {
        try storageAPI.save(favoriteIds, forKey: favoritesKey)
    }
    
    /// Fetches the array of favorite club IDs from storage.
    ///
    /// - Returns: Array of favorite club IDs, or empty array if no favorites exist
    /// - Throws: `FavoritesStorageError` if loading fails
    public func fetchFavorites() throws -> [Int] {
        try storageAPI.load([Int].self, forKey: favoritesKey) ?? []
    }
    
    /// Clears all favorites from storage.
    ///
    /// - Throws: `FavoritesStorageError` if the operation fails
    public func clearAllFavorites() throws {
        try saveFavorites([])
    }
}
