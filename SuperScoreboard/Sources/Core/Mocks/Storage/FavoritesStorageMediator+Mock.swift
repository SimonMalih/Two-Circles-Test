//
//  FavoritesStorageMediator+Mock.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import Domain
import Core

extension FavoritesStorageMediator {
    
    /// Creates a mock FavoritesStorageMediator for testing and previews.
    ///
    /// - Parameters:
    ///   - favoriteIds: Initial favorite club IDs to populate the mock with
    ///   - shouldFail: If true, operations will simulate failures
    /// - Returns: Configured FavoritesStorageMediator with MockStorageAPI
    static func mock(
        favoriteIds: [Int] = [],
        shouldFail: Bool = false
    ) -> FavoritesStorageMediator {
        let storage = MockStorageAPI(
            storage: ["favorite_club_ids": favoriteIds],
            shouldFail: shouldFail
        )
        return FavoritesStorageMediator(storageAPI: storage)
    }
    
    /// Creates a mock FavoritesStorageMediator populated with common favorite clubs.
    static let preview: FavoritesStorageMediator = mock(favoriteIds: [1, 10, 12]) // Arsenal, Liverpool, Man Utd
    static let empty: FavoritesStorageMediator = mock()
    static let failing: FavoritesStorageMediator = mock(shouldFail: true)
}