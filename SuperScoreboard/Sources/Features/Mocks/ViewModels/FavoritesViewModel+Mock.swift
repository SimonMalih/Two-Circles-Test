import Domain
import Core

extension FavoritesViewModel {
    
    /// Creates a mock FavoritesViewModel for testing and previews.
    ///
    /// - Parameters:
    ///   - favoriteIds: Initial favorite club IDs
    ///   - matches: Match data to extract clubs from
    ///   - shouldFail: If true, storage operations will simulate failures
    /// - Returns: Configured FavoritesViewModel for testing
    static func mock(
        favoriteIds: [Int] = [],
        matches: [Match] = [],
        shouldFail: Bool = false
    ) -> FavoritesViewModel {
        let initialData: [String: Codable] = favoriteIds.isEmpty ? [:] : ["favorite_club_ids": favoriteIds]
        let mockStorageAPI = MockStorageAPI(
            initialData: initialData,
            shouldFail: shouldFail
        )
        
        return FavoritesViewModel(
            storageAPI: mockStorageAPI,
            matches: matches
        )
    }
    
    /// Creates a preview-ready FavoritesViewModel with sample data.
    static var preview: FavoritesViewModel {
        mock(
            favoriteIds: [1, 10, 12], // Arsenal, Liverpool, Man Utd
            matches: Match.previewMatches
        )
    }
    
    /// Creates an empty FavoritesViewModel with no favorites or matches.
    static var empty: FavoritesViewModel {
        mock()
    }
    
    /// Creates a FavoritesViewModel with matches but no existing favorites.
    static var withMatches: FavoritesViewModel {
        mock(matches: Match.previewMatches)
    }
    
    /// Creates a FavoritesViewModel that simulates storage failures.
    static var failing: FavoritesViewModel {
        let viewModel = mock(shouldFail: true)
        viewModel.errorMessage = "Storage operation failed"
        return viewModel
    }
    
    /// Creates a FavoritesViewModel in loading state.
    static var loading: FavoritesViewModel {
        let viewModel = mock(matches: Match.previewMatches)
        viewModel.isLoading = true
        return viewModel
    }
}
