import Testing
import Foundation
@testable import Domain
@testable import Core

/// Unit tests for simplified FavoritesStorageMediator functionality.
struct FavoritesStorageMediatorTests {
    
    @Test("Save and fetch favorites successfully")
    func testSaveAndFetchFavorites() async throws {
        let storage = MockStorageAPI()
        let mediator = FavoritesStorageMediator(storageAPI: storage)
        
        let favoriteIds = [1, 2, 3, 4, 5]
        try mediator.saveFavorites(favoriteIds)
        
        let fetchedIds = try mediator.fetchFavorites()
        #expect(fetchedIds == favoriteIds)
    }
    
    @Test("Fetch empty favorites when none exist")
    func testFetchEmptyFavorites() async throws {
        let storage = MockStorageAPI()
        let mediator = FavoritesStorageMediator(storageAPI: storage)
        
        let fetchedIds = try mediator.fetchFavorites()
        #expect(fetchedIds.isEmpty)
    }
    
    @Test("Save overwrites existing favorites")
    func testSaveOverwritesExistingFavorites() async throws {
        let storage = MockStorageAPI()
        let mediator = FavoritesStorageMediator(storageAPI: storage)
        
        // Save initial favorites
        try mediator.saveFavorites([1, 2, 3])
        
        // Save new favorites (should overwrite)
        try mediator.saveFavorites([4, 5, 6])
        
        let fetchedIds = try mediator.fetchFavorites()
        #expect(fetchedIds == [4, 5, 6])
    }
    
    @Test("Clear all favorites")
    func testClearAllFavorites() async throws {
        let storage = MockStorageAPI()
        let mediator = FavoritesStorageMediator(storageAPI: storage)
        
        // Setup initial favorites
        try mediator.saveFavorites([1, 2, 3, 4, 5])
        
        try mediator.clearAllFavorites()
        
        let favorites = try mediator.fetchFavorites()
        #expect(favorites.isEmpty)
    }
    
    @Test("Handle storage failure on save")
    func testSaveFailure() async throws {
        let storage = MockStorageAPI(shouldFail: true)
        let mediator = FavoritesStorageMediator(storageAPI: storage)
        
        #expect(throws: MockStorageError.self) {
            try mediator.saveFavorites([1, 2, 3])
        }
    }
    
    @Test("Handle storage failure on fetch")
    func testFetchFailure() async throws {
        let storage = MockStorageAPI(shouldFail: true)
        let mediator = FavoritesStorageMediator(storageAPI: storage)
        
        #expect(throws: MockStorageError.self) {
            try mediator.fetchFavorites()
        }
    }
    
    @Test("Handle storage failure on clear")
    func testClearFailure() async throws {
        let storage = MockStorageAPI(shouldFail: true)
        let mediator = FavoritesStorageMediator(storageAPI: storage)
        
        #expect(throws: MockStorageError.self) {
            try mediator.clearAllFavorites()
        }
    }
}