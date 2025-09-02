import Testing
import Domain
import Core
@testable import SuperScoreboard

@Suite struct FavoritesViewModelTests {
    
    @Test("init loads existing favorites and sets up clubs from matches")
    func init_loadsExistingFavoritesAndSetsUpClubsFromMatches() async throws {
        // Given
        let existingFavorites = [1, 2, 3]
        let matches = Match.previewMatches
        
        // When
        let sut = makeFavoritesViewModel(
            favoriteIds: existingFavorites,
            matches: matches
        )
        
        // Then
        #expect(!sut.availableClubs.isEmpty)
        #expect(sut.selectedClubIds == Set(existingFavorites))
        #expect(sut.existingFavoriteIds == Set(existingFavorites))
        #expect(sut.errorMessage == nil)
        #expect(!sut.isLoading)
    }
    
    @Test("init with empty matches creates empty clubs array")
    func init_withEmptyMatches_createsEmptyClubsArray() async throws {
        // Given
        let matches: [Match] = []
        
        // When
        let sut = makeFavoritesViewModel(matches: matches)
        
        // Then
        #expect(sut.availableClubs.isEmpty)
        #expect(sut.selectedClubIds.isEmpty)
        #expect(sut.existingFavoriteIds.isEmpty)
    }
    
    @Test("updateClubs refreshes available clubs and reloads favorites")
    func updateClubs_refreshesAvailableClubsAndReloadsFavorites() async throws {
        // Given
        let sut = makeFavoritesViewModel()
        let newMatches = Match.previewMatches
        let initialClubCount = sut.availableClubs.count
        
        // When
        sut.updateClubs(from: newMatches)
        
        // Then
        #expect(sut.availableClubs.count != initialClubCount)
        #expect(!sut.availableClubs.isEmpty)
    }
    
    @Test("toggleClubSelection adds club when not selected")
    func toggleClubSelection_addsClubWhenNotSelected() async throws {
        // Given
        let sut = makeFavoritesViewModel(matches: Match.previewMatches)
        let club = sut.availableClubs.first!
        #expect(!sut.selectedClubIds.contains(club.id))
        
        // When
        sut.toggleClubSelection(club)
        
        // Then
        #expect(sut.selectedClubIds.contains(club.id))
    }
    
    @Test("toggleClubSelection removes club when already selected")
    func toggleClubSelection_removesClubWhenAlreadySelected() async throws {
        // Given
        let matches = Match.previewMatches
        let club = matches.first!.teams.first!.team.club
        let sut = makeFavoritesViewModel(
            favoriteIds: [club.id],
            matches: matches
        )
        #expect(sut.selectedClubIds.contains(club.id))
        
        // When
        sut.toggleClubSelection(club)
        
        // Then
        #expect(!sut.selectedClubIds.contains(club.id))
    }
    
    @Test("isClubSelected returns true for selected clubs")
    func isClubSelected_returnsTrueForSelectedClubs() async throws {
        // Given
        let matches = Match.previewMatches
        let club = matches.first!.teams.first!.team.club
        let sut = makeFavoritesViewModel(
            favoriteIds: [club.id],
            matches: matches
        )
        
        // When
        let isSelected = sut.isClubSelected(club)
        
        // Then
        #expect(isSelected)
    }
    
    @Test("isClubSelected returns false for unselected clubs")
    func isClubSelected_returnsFalseForUnselectedClubs() async throws {
        // Given
        let sut = makeFavoritesViewModel(matches: Match.previewMatches)
        let club = sut.availableClubs.first!
        
        // When
        let isSelected = sut.isClubSelected(club)
        
        // Then
        #expect(!isSelected)
    }
    
    @Test("shouldHighlightClub returns true for selected clubs")
    func shouldHighlightClub_returnsTrueForSelectedClubs() async throws {
        // Given
        let matches = Match.previewMatches
        let club = matches.first!.teams.first!.team.club
        let sut = makeFavoritesViewModel(
            favoriteIds: [club.id],
            matches: matches
        )
        
        // When
        let shouldHighlight = sut.shouldHighlightClub(club)
        
        // Then
        #expect(shouldHighlight)
    }
    
    @Test("shouldHighlightClub returns false for unselected clubs")
    func shouldHighlightClub_returnsFalseForUnselectedClubs() async throws {
        // Given
        let sut = makeFavoritesViewModel(matches: Match.previewMatches)
        let club = sut.availableClubs.first!
        
        // When
        let shouldHighlight = sut.shouldHighlightClub(club)
        
        // Then
        #expect(!shouldHighlight)
    }
    
    @Test("saveFavorites successfully saves selected clubs")
    func saveFavorites_successfullySavesSelectedClubs() async throws {
        // Given
        let sut = makeFavoritesViewModel()
        let clubId = 42
        sut.selectedClubIds.insert(clubId)
        
        // When
        await sut.saveFavorites()
        
        // Then
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
        #expect(sut.existingFavoriteIds.contains(clubId))
    }
    
    @Test("saveFavorites sets loading state during operation")
    func saveFavorites_setsLoadingStateDuringOperation() async throws {
        // Given
        let sut = makeFavoritesViewModel()
        sut.selectedClubIds.insert(42)
        
        // When
        await sut.saveFavorites()
        
        // Then - Check final state after completion
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("saveFavorites handles storage failure")
    func saveFavorites_handlesStorageFailure() async throws {
        // Given
        let sut = makeFavoritesViewModel(shouldFail: true)
        sut.selectedClubIds.insert(42)
        
        // When
        await sut.saveFavorites()
        
        // Then
        #expect(!sut.isLoading)
        #expect(sut.errorMessage != nil)
    }
    
    @Test("resetSelections restores existing favorites state")
    func resetSelections_restoresExistingFavoritesState() async throws {
        // Given
        let existingFavorites = [1, 2, 3]
        let sut = makeFavoritesViewModel(favoriteIds: existingFavorites)
        sut.selectedClubIds = [4, 5, 6] // Modify selections
        sut.errorMessage = "Some error"
        
        // When
        sut.resetSelections()
        
        // Then
        #expect(sut.selectedClubIds == Set(existingFavorites))
        #expect(sut.errorMessage == nil)
    }
    
    @Test("clearAllSelections removes all selections and favorites")
    func clearAllSelections_removesAllSelectionsAndFavorites() async throws {
        // Given
        let sut = makeFavoritesViewModel(favoriteIds: [1, 2, 3])
        
        // When
        await sut.clearAllSelections()
        
        // Then
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
        #expect(sut.selectedClubIds.isEmpty)
        #expect(sut.existingFavoriteIds.isEmpty)
    }
    
    @Test("clearAllSelections sets loading state during operation")
    func clearAllSelections_setsLoadingStateDuringOperation() async throws {
        // Given
        let sut = makeFavoritesViewModel(favoriteIds: [1, 2, 3])
        
        // When
        await sut.clearAllSelections()
        
        // Then - Check final state after completion
        #expect(!sut.isLoading)
        #expect(sut.errorMessage == nil)
        #expect(sut.selectedClubIds.isEmpty)
        #expect(sut.existingFavoriteIds.isEmpty)
    }
    
    @Test("clearAllSelections handles storage failure")
    func clearAllSelections_handlesStorageFailure() async throws {
        // Given
        let sut = makeFavoritesViewModel(
            favoriteIds: [1, 2, 3],
            shouldFail: true
        )
        
        // When
        await sut.clearAllSelections()
        
        // Then
        #expect(!sut.isLoading)
        #expect(sut.errorMessage != nil)
    }
    
    @Test("hasUnsavedChanges returns false when selections match existing favorites")
    func hasUnsavedChanges_returnsFalseWhenSelectionsMatchExistingFavorites() async throws {
        // Given
        let favoriteIds = [1, 2, 3]
        let sut = makeFavoritesViewModel(favoriteIds: favoriteIds)
        
        // When
        let hasChanges = sut.hasUnsavedChanges
        
        // Then
        #expect(!hasChanges)
    }
    
    @Test("hasUnsavedChanges returns true when selections differ from existing favorites")
    func hasUnsavedChanges_returnsTrueWhenSelectionsDifferFromExistingFavorites() async throws {
        // Given
        let sut = makeFavoritesViewModel(favoriteIds: [1, 2, 3])
        sut.selectedClubIds = [4, 5, 6]
        
        // When
        let hasChanges = sut.hasUnsavedChanges
        
        // Then
        #expect(hasChanges)
    }
    
    @Test("selectedCount returns correct count of selected clubs")
    func selectedCount_returnsCorrectCountOfSelectedClubs() async throws {
        // Given
        let sut = makeFavoritesViewModel()
        sut.selectedClubIds = [1, 2, 3, 4, 5]
        
        // When
        let count = sut.selectedCount
        
        // Then
        #expect(count == 5)
    }
    
    @Test("selectedCount returns zero for empty selections")
    func selectedCount_returnsZeroForEmptySelections() async throws {
        // Given
        let sut = makeFavoritesViewModel()
        sut.selectedClubIds = []
        
        // When
        let count = sut.selectedCount
        
        // Then
        #expect(count == 0)
    }
    
    @Test("getUniqueClubs extracts and sorts clubs from matches")
    func getUniqueClubs_extractsAndSortsClubsFromMatches() async throws {
        // Given
        let matches = [
            Match(
                id: 1,
                kickoff: .upcoming,
                competition: .premierLeague,
                teams: [.arsenal, .brighton],
                ground: .emirates,
                status: .upcoming,
                attendance: nil,
                clock: nil,
                goals: nil
            ),
            Match(
                id: 2,
                kickoff: .live,
                competition: .premierLeague,
                teams: [.liverpool, .arsenal], // Arsenal is duplicate
                ground: .emirates,
                status: .inProgress,
                attendance: nil,
                clock: nil,
                goals: nil
            )
        ]
        
        // When
        let sut = makeFavoritesViewModel(matches: matches)
        
        // Then
        #expect(sut.availableClubs.count == 3)
        let clubNames = sut.availableClubs.map { $0.name }
        #expect(clubNames == ["Arsenal", "Brighton and Hove Albion", "Liverpool"]) // Sorted alphabetically
    }
    
    @Test("getUniqueClubs handles empty matches")
    func getUniqueClubs_handlesEmptyMatches() async throws {
        // Given
        let matches: [Match] = []
        
        // When
        let sut = makeFavoritesViewModel(matches: matches)
        
        // Then
        #expect(sut.availableClubs.isEmpty)
    }
    
    @Test("loadExistingFavorites handles storage failure")
    func loadExistingFavorites_handlesStorageFailure() async throws {
        // Given & When
        let sut = makeFavoritesViewModel(shouldFail: true)
        
        // Then
        #expect(sut.errorMessage != nil)
        #expect(sut.existingFavoriteIds.isEmpty)
        #expect(sut.selectedClubIds.isEmpty)
    }
    
    @Test("viewModel maintains state consistency during multiple operations")
    func viewModel_maintainsStateConsistencyDuringMultipleOperations() async throws {
        // Given
        let matches = Match.previewMatches
        let sut = makeFavoritesViewModel(matches: matches)
        let club = sut.availableClubs.first!
        
        // When & Then - Add selection
        sut.toggleClubSelection(club)
        #expect(sut.selectedClubIds.contains(club.id))
        #expect(sut.hasUnsavedChanges)
        
        // When & Then - Save
        await sut.saveFavorites()
        #expect(sut.existingFavoriteIds.contains(club.id))
        #expect(!sut.hasUnsavedChanges)
        
        // When & Then - Remove selection
        sut.toggleClubSelection(club)
        #expect(!sut.selectedClubIds.contains(club.id))
        #expect(sut.hasUnsavedChanges)
        
        // When & Then - Reset
        sut.resetSelections()
        #expect(sut.selectedClubIds.contains(club.id))
        #expect(!sut.hasUnsavedChanges)
    }
}

// MARK: - Test Helpers

private extension FavoritesViewModelTests {
    
    func makeFavoritesViewModel(
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
}
