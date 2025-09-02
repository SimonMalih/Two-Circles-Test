//
//  RemoteMatchServiceTests.swift
//  Domain
//
//  Created by Simon Malih on 01/09/2025.
//

import Testing
import Foundation
@testable import Domain
@testable import Core

@Suite struct RemoteMatchServiceTests {
    
    @Test("fetchMatches delegates to data source successfully")
    func fetchMatches_delegatesToDataSourceSuccessfully() async throws {
        // Given
        let expectedMatches = createTestMatches()
        let mockDataSource = MockDataSource(result: .success(expectedMatches))
        let sut = RemoteMatchService(dataSource: mockDataSource)
        
        // When
        let matches = try await sut.fetchMatches()
        
        // Then
        #expect(matches.count == expectedMatches.count)
        #expect(matches.first?.id == expectedMatches.first?.id)
        #expect(mockDataSource.executeCallCount == 1)
    }
    
    @Test("fetchMatches throws error when data source fails")
    func fetchMatches_throwsErrorWhenDataSourceFails() async throws {
        // Given
        let expectedError = MockDataSourceError.networkFailure
        let mockDataSource = MockDataSource<[Match]>(result: .failure(expectedError))
        let sut = RemoteMatchService(dataSource: mockDataSource)
        
        // When & Then
        await #expect(throws: MockDataSourceError.self) {
            try await sut.fetchMatches()
        }
        #expect(mockDataSource.executeCallCount == 1)
    }
}

// MARK: - Test Helpers

private extension RemoteMatchServiceTests {
    
    private enum MockDataSourceError: Error, Equatable {
        case networkFailure
    }
    
    private func createTestMatches() -> [Match] {
        [createTestMatch()]
    }
    
    private func createTestMatch() -> Match {
        let homeTeam = MatchTeam(
            team: Team(
                id: 1,
                name: "Arsenal",
                shortName: "ARS",
                teamType: "FIRST",
                club: Club(id: 1, name: "Arsenal", abbr: "ARS", shortName: "Arsenal"),
                altIds: nil
            ),
            score: 2
        )
        
        let awayTeam = MatchTeam(
            team: Team(
                id: 2,
                name: "Liverpool",
                shortName: "LIV",
                teamType: "FIRST",
                club: Club(id: 2, name: "Liverpool", abbr: "LIV", shortName: "Liverpool"),
                altIds: nil
            ),
            score: 1
        )
        
        return Match(
            id: 1,
            kickoff: Kickoff(
                completeness: 3,
                millis: 1732569600000, // Nov 25, 2024
                label: "Mon 25 Nov 2024, 20:00 GMT"
            ),
            competition: Competition(id: 1, title: "Premier League"),
            teams: [homeTeam, awayTeam],
            ground: Ground(
                id: 1,
                name: "Emirates Stadium",
                city: "London",
                source: "OPTA"
            ),
            status: .completed,
            attendance: 59867,
            clock: nil,
            goals: nil
        )
    }
}

