import Testing
import Domain
@testable import SuperScoreboard

@Suite struct CompetitionMatchesViewModelTests {
    
    @Test("init with all parameters creates viewModel with correct properties")
    func init_withAllParameters_createsViewModelWithCorrectProperties() async throws {
        // Given
        let competition = Competition.premierLeague
        let competitionTitle = "Premier League"
        let matches = [makeMatchCardData()]
        let favoritesRepository = MockFavouritesRepository()
        
        // When
        let sut = CompetitionMatchesViewModel(
            competition: competition,
            competitionTitle: competitionTitle,
            matches: matches,
            favoritesRepository: favoritesRepository
        )
        
        // Then
        #expect(sut.competition?.id == competition.id)
        #expect(sut.competitionTitle == competitionTitle)
        #expect(sut.matches.count == matches.count)
        #expect(sut.matches.first?.match.id == matches.first?.match.id)
        #expect(sut.favoritesRepository.favoriteClubIds == favoritesRepository.favoriteClubIds)
    }
    
    @Test("viewModel works with favoritesRepository operations")
    func viewModel_worksWithFavoritesRepositoryOperations() async throws {
        // Given
        let competition = Competition.premierLeague
        let competitionTitle = "Premier League"
        let matches = [makeMatchCardData()]
        let favoritesRepository = MockFavouritesRepository()
        
        let sut = CompetitionMatchesViewModel(
            competition: competition,
            competitionTitle: competitionTitle,
            matches: matches,
            favoritesRepository: favoritesRepository
        )
        
        // When
        let clubId = matches.first?.homeTeamId ?? 1
        sut.favoritesRepository.addFavorite(clubId: clubId)
        
        // Then
        #expect(sut.favoritesRepository.isFavorite(clubId: clubId))
        #expect(sut.favoritesRepository.favoriteClubIds.contains(clubId))
    }
}

// MARK: - Test Helpers

private extension CompetitionMatchesViewModelTests {
    
    func makeMatchCardData(matchId: Int = 1) -> MatchCardData {
        let homeTeam = MatchTeam(team: .arsenal, score: 2)
        let awayTeam = MatchTeam(team: .liverpool, score: 1)
        let match = Match(
            id: matchId,
            kickoff: .upcoming,
            competition: .premierLeague,
            teams: [homeTeam, awayTeam],
            ground: .emirates,
            status: .upcoming,
            attendance: nil,
            clock: nil,
            goals: nil
        )
        
        return MatchCardData(
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            homeScore: "2",
            awayScore: "1",
            shouldShowScores: true,
            match: match
        )
    }
}
