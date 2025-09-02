//
//  FavouritesRepositoryTests.swift
//  Domain
//
//  Created by Simon Malih on 01/09/2025.
//

import Testing
import Foundation
@testable import Domain
@testable import Core

@Suite struct FavouritesRepositoryTests {
    
    @Test("isFavorite returns true for favorite club IDs")
    func isFavorite_returnsTrueForFavoriteClubIds() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2, 3]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        // When & Then
        #expect(sut.isFavorite(clubId: 1) == true)
        #expect(sut.isFavorite(clubId: 2) == true)
        #expect(sut.isFavorite(clubId: 3) == true)
        #expect(sut.isFavorite(clubId: 4) == false)
    }
    
    @Test("addFavorite adds club ID to favorites and persists changes")
    func addFavorite_addsClubIdToFavoritesAndPersistsChanges() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        var saveCalled = false
        var savedKey: String?
        var savedValue: Any?
        
        mockStorageAPI.onSave = { value, key in
            saveCalled = true
            savedKey = key
            savedValue = value
        }
        
        // When
        sut.addFavorite(clubId: 3)
        
        // Then
        #expect(sut.favoriteClubIds.contains(3))
        #expect(sut.favoriteClubIds.count == 3)
        
        // Wait for save operation to be called
        try await #expect(eventually: saveCalled == true, within: .seconds(1))
        #expect(savedKey == "favorite_club_ids")
        if let savedIds = savedValue as? [Int] {
            #expect(savedIds.contains(3))
        }
        
        // Verify it was saved to storage
        let savedIds = try mockStorageAPI.load([Int].self, forKey: "favorite_club_ids") ?? []
        #expect(savedIds.contains(3))
    }
    
    @Test("addFavorite does not duplicate existing favorites")
    func addFavorite_doesNotDuplicateExistingFavorites() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        var saveCalled = false
        mockStorageAPI.onSave = { _, _ in
            saveCalled = true
        }
        
        // When
        sut.addFavorite(clubId: 2)
        
        // Then
        #expect(sut.favoriteClubIds.count == 2)
        try await #expect(eventually: saveCalled == true, within: .seconds(1))
    }
    
    @Test("removeFavorite removes club ID from favorites and persists changes")
    func removeFavorite_removesClubIdFromFavoritesAndPersistsChanges() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2, 3]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        var saveCalled = false
        var savedKey: String?
        var savedValue: Any?
        
        mockStorageAPI.onSave = { value, key in
            saveCalled = true
            savedKey = key
            savedValue = value
        }
        
        // When
        sut.removeFavorite(clubId: 2)
        
        // Then
        #expect(!sut.favoriteClubIds.contains(2))
        #expect(sut.favoriteClubIds.count == 2)
        
        try await #expect(eventually: saveCalled == true, within: .seconds(1))
        #expect(savedKey == "favorite_club_ids")
        if let savedIds = savedValue as? [Int] {
            #expect(!savedIds.contains(2))
        }
        
        // Verify it was removed from storage
        let savedIds = try mockStorageAPI.load([Int].self, forKey: "favorite_club_ids") ?? []
        #expect(!savedIds.contains(2))
    }
    
    @Test("removeFavorite handles non-existing club ID gracefully")
    func removeFavorite_handlesNonExistingClubIdGracefully() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        var saveCalled = false
        mockStorageAPI.onSave = { _, _ in
            saveCalled = true
        }
        
        // When
        sut.removeFavorite(clubId: 99)
        
        // Then
        #expect(sut.favoriteClubIds.count == 2)
        try await #expect(eventually: saveCalled == true, within: .seconds(1))
    }
    
    @Test("toggleFavorite adds club ID when not favorite")
    func toggleFavorite_addsClubIdWhenNotFavorite() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        var saveCalled = false
        var savedKey: String?
        var savedValue: Any?
        
        mockStorageAPI.onSave = { value, key in
            saveCalled = true
            savedKey = key
            savedValue = value
        }
        
        // When
        sut.toggleFavorite(clubId: 3)
        
        // Then
        #expect(sut.favoriteClubIds.contains(3))
        #expect(sut.favoriteClubIds.count == 3)
        
        try await #expect(eventually: saveCalled == true, within: .seconds(1))
        #expect(savedKey == "favorite_club_ids")
        if let savedIds = savedValue as? [Int] {
            #expect(savedIds.contains(3))
        }
    }
    
    @Test("toggleFavorite removes club ID when already favorite")
    func toggleFavorite_removesClubIdWhenAlreadyFavorite() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2, 3]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        var saveCalled = false
        var savedKey: String?
        var savedValue: Any?
        
        mockStorageAPI.onSave = { value, key in
            saveCalled = true
            savedKey = key
            savedValue = value
        }
        
        // When
        sut.toggleFavorite(clubId: 2)
        
        // Then
        #expect(!sut.favoriteClubIds.contains(2))
        #expect(sut.favoriteClubIds.count == 2)
        
        try await #expect(eventually: saveCalled == true, within: .seconds(1))
        #expect(savedKey == "favorite_club_ids")
        if let savedIds = savedValue as? [Int] {
            #expect(!savedIds.contains(2))
        }
    }
    
    @Test("updateFavorites replaces entire favorites set and persists changes")
    func updateFavorites_replacesEntireFavoritesSetAndPersistsChanges() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        var saveCalled = false
        var savedKey: String?
        var savedValue: Any?
        
        mockStorageAPI.onSave = { value, key in
            saveCalled = true
            savedKey = key
            savedValue = value
        }
        
        // When
        sut.updateFavorites(Set([5, 6, 7]))
        
        // Then
        #expect(sut.favoriteClubIds == Set([5, 6, 7]))
        
        try await #expect(eventually: saveCalled == true, within: .seconds(1))
        #expect(savedKey == "favorite_club_ids")
        if let savedIds = savedValue as? [Int] {
            #expect(Set(savedIds) == Set([5, 6, 7]))
        }
        
        // Verify it was saved to storage
        let savedIds = try mockStorageAPI.load([Int].self, forKey: "favorite_club_ids") ?? []
        #expect(Set(savedIds) == Set([5, 6, 7]))
    }
    
    @Test("refresh reloads favorites from storage")
    func refresh_reloadsFavoritesFromStorage() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        var loadCount = 0
        var lastLoadedKey: String?
        
        mockStorageAPI.onLoad = { key in
            loadCount += 1
            lastLoadedKey = key
            return nil
        }
        
        // Modify storage externally
        try mockStorageAPI.save([10, 20, 30], forKey: "favorite_club_ids")
        
        // When
        sut.refresh()
        
        // Then
        #expect(sut.favoriteClubIds == Set([10, 20, 30]))
        try await #expect(eventually: loadCount == 2, within: .seconds(1)) // Once during init, once during refresh
        #expect(lastLoadedKey == "favorite_club_ids")
    }
    
    @Test("initialization handles storage load failure gracefully")
    func initialization_handlesStorageLoadFailureGracefully() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(shouldFail: true)
        
        // When
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        // Then
        #expect(sut.favoriteClubIds.isEmpty)
    }
    
    @Test("refresh handles storage load failure gracefully")
    func refresh_handlesStorageLoadFailureGracefully() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        // Configure storage to fail
        mockStorageAPI.shouldFail = true
        
        // When
        sut.refresh()
        
        // Then - Favorites should be reset to empty on load failure
        #expect(sut.favoriteClubIds.isEmpty)
    }
    
    @Test("save operations handle storage failure gracefully")
    func saveOperations_handleStorageFailureGracefully() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1]], shouldFail: true)
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        // When & Then - Operations should not crash even when save fails
        sut.addFavorite(clubId: 2)
        #expect(sut.favoriteClubIds.contains(2)) // State is updated locally
        
        sut.removeFavorite(clubId: 1)
        #expect(!sut.favoriteClubIds.contains(1)) // State is updated locally
        
        sut.updateFavorites(Set([5, 6]))
        #expect(sut.favoriteClubIds == Set([5, 6])) // State is updated locally
    }
    
    @Test("favoriteClubIds provides read-only access to internal state")
    func favoriteClubIds_providesReadOnlyAccessToInternalState() async throws {
        // Given
        let mockStorageAPI = MockStorageAPI(initialData: ["favorite_club_ids": [1, 2, 3]])
        let sut = FavouritesRepository(storageAPI: mockStorageAPI)
        
        // When
        let favoriteIds = sut.favoriteClubIds
        
        // Then
        #expect(favoriteIds == Set([1, 2, 3]))
        // favoriteClubIds is private(set) so we can't modify it directly - this is verified at compile time
    }
}
