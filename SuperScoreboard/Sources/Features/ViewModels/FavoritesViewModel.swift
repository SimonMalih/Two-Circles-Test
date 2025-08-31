//
//  FavoritesViewModel.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import Observation
import Domain
import Core

/// ViewModel for favorites selection with club management and persistence.
@Observable
public final class FavoritesViewModel {
    
    public var isLoading = false
    public var errorMessage: String?
    public private(set) var availableClubs: [Club] = []
    public var selectedClubIds: Set<Int> = []
    public private(set) var existingFavoriteIds: Set<Int> = []
    
    private let storageMediator: FavoritesStorageMediator
    
    public init(
        storageMediator: FavoritesStorageMediator,
        matches: [Match] = []
    ) {
        self.storageMediator = storageMediator
        self.availableClubs = getUniqueClubs(from: matches)
        
        // Load existing favorites on initialization
        loadExistingFavorites()
    }
    
    public func updateClubs(from matches: [Match]) {
        availableClubs = getUniqueClubs(from: matches)
        loadExistingFavorites()
    }
    
    public func toggleClubSelection(_ club: Club) {
        if selectedClubIds.contains(club.id) {
            selectedClubIds.remove(club.id)
        } else {
            selectedClubIds.insert(club.id)
        }
    }
    
    /// Checks if a club is currently selected.
    ///
    /// - Parameter club: The club to check
    /// - Returns: true if the club is selected, false otherwise
    public func isClubSelected(_ club: Club) -> Bool {
        return selectedClubIds.contains(club.id)
    }
    
    /// Checks if a club should be highlighted (currently selected).
    ///
    /// - Parameter club: The club to check
    /// - Returns: true if the club should be visually highlighted, false otherwise
    public func shouldHighlightClub(_ club: Club) -> Bool {
        return selectedClubIds.contains(club.id)
    }
    
    /// Saves the currently selected clubs as favorites.
    ///
    /// This method persists all currently selected clubs, replacing any existing
    /// favorites with the new selection.
    public func saveFavorites() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let selectedIds = Array(selectedClubIds)
            try storageMediator.saveFavorites(selectedIds)
            
            // Update existing favorites to reflect the new state
            existingFavoriteIds = selectedClubIds
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Loads existing favorites and populates the selectedClubIds.
    ///
    /// This method is called during initialization and when clubs are updated
    /// to ensure the UI shows the current favorite state.
    private func loadExistingFavorites() {
        do {
            let favoriteIds = try storageMediator.fetchFavorites()
            existingFavoriteIds = Set(favoriteIds)
            selectedClubIds = Set(favoriteIds)
        } catch {
            errorMessage = error.localizedDescription
            existingFavoriteIds = []
            selectedClubIds = []
        }
    }
    
    /// Resets all selections to the existing favorites state.
    ///
    /// This method can be used to cancel changes and revert to the saved state.
    public func resetSelections() {
        selectedClubIds = existingFavoriteIds
        errorMessage = nil
    }
    
    /// Clears all selected clubs and favorites.
    public func clearAllSelections() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try storageMediator.clearAllFavorites()
            selectedClubIds.removeAll()
            existingFavoriteIds.removeAll()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Checks if there are any unsaved changes.
    ///
    /// - Returns: true if current selections differ from saved favorites
    public var hasUnsavedChanges: Bool {
        return selectedClubIds != existingFavoriteIds
    }
    
    /// Gets the count of currently selected clubs.
    public var selectedCount: Int {
        return selectedClubIds.count
    }
    
    /// Extracts unique clubs from matches, sorted by name.
    private func getUniqueClubs(from matches: [Match]) -> [Club] {
        var clubsById: [Int: Club] = [:]
        
        // Extract all clubs from all matches
        for match in matches {
            for team in match.teams {
                let club = team.team.club
                clubsById[club.id] = club
            }
        }
        
        // Return sorted by name for consistent UI ordering
        return clubsById.values.sorted { $0.name < $1.name }
    }
}
