//
//  FavouritesRepository.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import Observation

/// Observable repository for managing favourite clubs with real-time updates.
/// Provides a single source of truth for favourite state across the app.
@Observable
public final class FavouritesRepository: FavouritesRepositoryProtocol {
    
    /// Set of favorite club IDs for efficient lookup
    public private(set) var favoriteClubIds: Set<Int> = []
    private let storageMediator: FavoritesStorageMediator
    
    public init(storageMediator: FavoritesStorageMediator) {
        self.storageMediator = storageMediator
        loadFavorites()
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
        saveFavorites()
    }
    
    /// Removes a club from favorites
    /// - Parameter clubId: The club ID to remove
    public func removeFavorite(clubId: Int) {
        favoriteClubIds.remove(clubId)
        saveFavorites()
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
        saveFavorites()
    }
    
    /// Refreshes favorites from storage
    /// Useful for ensuring consistency after external changes
    public func refresh() {
        loadFavorites()
    }
        
    private func loadFavorites() {
        do {
            let ids = try storageMediator.fetchFavorites()
            favoriteClubIds = Set(ids)
        } catch {
            favoriteClubIds = []
        }
    }
    
    private func saveFavorites() {
        do {
            try storageMediator.saveFavorites(Array(favoriteClubIds))
        } catch {
            // In a production app, you might want to handle this error more gracefully
            print("Failed to save favorites: \(error)")
        }
    }
}
