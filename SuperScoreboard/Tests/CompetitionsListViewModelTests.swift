import Testing
import Domain
import Core
@testable import SuperScoreboard

@Suite struct CompetitionsListViewModelTests {
    
    @Test("fetchMatches with successful data loads matches and updates state to loaded")
    func fetchMatches_withSuccessfulData_loadsMatchesAndUpdatesStateToLoaded() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        let expectedMatches = Match.previewMatches
        mockService.setMatches(expectedMatches)
        
        // When
        await sut.fetchMatches()
        
        // Then
        #expect(sut.viewState == .loaded)
        #expect(sut.matches.count == expectedMatches.count)
        #expect(!sut.sectionsData.isEmpty)
    }
    
    @Test("fetchMatches with empty data updates state to empty")
    func fetchMatches_withEmptyData_updatesStateToEmpty() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        mockService.setMatches([])
        
        // When
        await sut.fetchMatches()
        
        // Then
        #expect(sut.viewState == .empty)
        #expect(sut.matches.isEmpty)
        #expect(sut.sectionsData.isEmpty)
    }
    
    @Test("fetchMatches with service failure updates state to error and clears data")
    func fetchMatches_withServiceFailure_updatesStateToErrorAndClearsData() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        mockService.setShouldFail(true)
        
        // When
        await sut.fetchMatches()
        
        // Then
        #expect(sut.viewState == .error)
        #expect(sut.matches.isEmpty)
        #expect(sut.sectionsData.isEmpty)
    }
    
    @Test("fetchMatches sets loading state initially")
    func fetchMatches_setsLoadingStateInitially() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        mockService.setMatches(Match.previewMatches)
        
        // When
        let fetchTask = Task {
            await sut.fetchMatches()
        }
        
        // Then - Check loading state is set immediately
        #expect(sut.viewState == .loading)
        
        // Wait for completion
        await fetchTask.value
        #expect(sut.viewState == .loaded)
    }
    
    @Test("calculateSectionsData groups matches by competition title")
    func calculateSectionsData_groupsMatchesByCompetitionTitle() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        let premierLeagueMatch = makeMatch(competition: .premierLeague)
        let championshipMatch = makeMatch(competition: Competition(id: 2, title: "Championship"))
        let matches = [premierLeagueMatch, championshipMatch]
        mockService.setMatches(matches)
        
        // When
        await sut.fetchMatches()
        
        // Then
        #expect(sut.sectionsData.count == 2)
        let sectionTitles = sut.sectionsData.map { $0.title }.sorted()
        #expect(sectionTitles == ["Championship", "Premier League"])
    }
    
    @Test("calculateSectionsData handles matches with nil competition")
    func calculateSectionsData_handlesMatchesWithNilCompetition() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        let matchWithCompetition = makeMatch(competition: .premierLeague)
        let matchWithoutCompetition = makeMatch(competition: nil)
        let matches = [matchWithCompetition, matchWithoutCompetition]
        mockService.setMatches(matches)
        
        // When
        await sut.fetchMatches()
        
        // Then
        #expect(sut.sectionsData.count == 2)
        let sectionTitles = sut.sectionsData.map { $0.title }.sorted()
        #expect(sectionTitles == ["Other", "Premier League"])
    }
    
    @Test("calculateSectionsData filters out matches with fewer than 2 teams")
    func calculateSectionsData_filtersOutMatchesWithFewerThanTwoTeams() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        let validMatch = makeMatch(teams: [.arsenal, .liverpool])
        let invalidMatch = makeMatch(teams: [.arsenal])
        let matches = [validMatch, invalidMatch]
        mockService.setMatches(matches)
        
        // When
        await sut.fetchMatches()
        
        // Then
        #expect(sut.sectionsData.count == 1)
        #expect(sut.sectionsData.first?.matches.count == 1)
    }
    
    @Test("calculateSectionsData sorts competition sections alphabetically")
    func calculateSectionsData_sortsCompetitionSectionsAlphabetically() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        let matches = [
            makeMatch(competition: .premierLeague),
            makeMatch(competition: Competition(id: 2, title: "Championship")),
            makeMatch(competition: Competition(id: 3, title: "League One"))
        ]
        mockService.setMatches(matches)
        
        // When
        await sut.fetchMatches()
        
        // Then
        let sectionTitles = sut.sectionsData.map { $0.title }
        #expect(sectionTitles == ["Championship", "League One", "Premier League"])
    }
    
    @Test("createMatchCardData creates valid data for match with two teams")
    func createMatchCardData_createsValidDataForMatchWithTwoTeams() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        let homeTeam = makeMatchTeam(team: .arsenal, score: 2)
        let awayTeam = makeMatchTeam(team: .liverpool, score: 1)
        let match = makeMatch(teams: [homeTeam, awayTeam])
        mockService.setMatches([match])
        
        // When
        await sut.fetchMatches()
        
        // Then
        let matchCardData = sut.sectionsData.first?.matches.first
        #expect(matchCardData != nil)
        #expect(matchCardData?.homeScore == "2")
        #expect(matchCardData?.awayScore == "1")
        #expect(matchCardData?.homeTeam.team.id == homeTeam.team.id)
        #expect(matchCardData?.awayTeam.team.id == awayTeam.team.id)
    }
    
    @Test("createMatchCardData handles matches with nil scores")
    func createMatchCardData_handlesMatchesWithNilScores() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        let homeTeam = makeMatchTeam(team: .arsenal, score: nil)
        let awayTeam = makeMatchTeam(team: .liverpool, score: nil)
        let match = makeMatch(teams: [homeTeam, awayTeam])
        mockService.setMatches([match])
        
        // When
        await sut.fetchMatches()
        
        // Then
        let matchCardData = sut.sectionsData.first?.matches.first
        #expect(matchCardData != nil)
        #expect(matchCardData?.homeScore == "0")
        #expect(matchCardData?.awayScore == "0")
    }
    
    @Test("createCompetitionSection includes competition data")
    func createCompetitionSection_includesCompetitionData() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        let competition = Competition.premierLeague
        let match = makeMatch(competition: competition)
        mockService.setMatches([match])
        
        // When
        await sut.fetchMatches()
        
        // Then
        let section = sut.sectionsData.first
        #expect(section?.competition?.id == competition.id)
        #expect(section?.title == "Premier League")
    }
    
    @Test("createCompetitionSection excludes invalid matches")
    func createCompetitionSection_excludesInvalidMatches() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        let validMatch = makeMatch(teams: [.arsenal, .liverpool])
        let invalidMatch = makeMatch(teams: [.arsenal])
        let matches = [validMatch, invalidMatch]
        mockService.setMatches(matches)
        
        // When
        await sut.fetchMatches()
        
        // Then
        let section = sut.sectionsData.first
        #expect(section?.matches.count == 1)
    }
    
    @Test("init creates viewModel with injected dependencies")
    func init_createsViewModelWithInjectedDependencies() async throws {
        // Given
        let mockService = MockMatchService()
        let mockStorage = FavoritesStorageMediator.mock()
        
        // When
        let sut = CompetitionsListViewModel(
            matchService: mockService,
            storageMediator: mockStorage
        )
        
        // Then
        #expect(sut.viewState == .loading)
        #expect(sut.matches.isEmpty)
        #expect(sut.sectionsData.isEmpty)
        #expect(sut.storageMediator === mockStorage)
    }
    
    @Test("viewModel maintains state consistency during multiple fetch operations")
    func viewModel_maintainsStateConsistencyDuringMultipleFetchOperations() async throws {
        // Given
        let (sut, mockService) = makeViewModelAndMockService()
        let firstMatches = [makeMatch(competition: .premierLeague)]
        let secondMatches = [makeMatch(competition: Competition(id: 2, title: "Championship"))]
        
        // When - First fetch
        mockService.setMatches(firstMatches)
        await sut.fetchMatches()
        
        // Then - First state
        #expect(sut.viewState == .loaded)
        #expect(sut.matches.count == firstMatches.count)
        #expect(sut.sectionsData.count == 1)
        #expect(sut.sectionsData.first?.title == "Premier League")
        
        // When - Second fetch
        mockService.setMatches(secondMatches)
        await sut.fetchMatches()
        
        // Then - Second state
        #expect(sut.viewState == .loaded)
        #expect(sut.matches.count == secondMatches.count)
        #expect(sut.sectionsData.count == 1)
        #expect(sut.sectionsData.first?.title == "Championship")
    }
}

// MARK: - Test Helpers

private extension CompetitionsListViewModelTests {
    
    func makeViewModelAndMockService() -> (sut: CompetitionsListViewModel, mockService: ConfigurableMockMatchService) {
        let mockService = ConfigurableMockMatchService()
        let mockStorage = FavoritesStorageMediator.mock()
        let sut = CompetitionsListViewModel(
            matchService: mockService,
            storageMediator: mockStorage
        )
        return (sut, mockService)
    }
    
    func makeMatch(
        id: Int = 1,
        kickoff: Kickoff = .upcoming,
        competition: Competition? = .premierLeague,
        teams: [MatchTeam] = [.arsenal, .liverpool],
        ground: Ground = .emirates,
        status: MatchStatus = .upcoming,
        attendance: Int? = nil,
        clock: Clock? = nil,
        goals: [Goal]? = nil
    ) -> Match {
        return Match(
            id: id,
            kickoff: kickoff,
            competition: competition,
            teams: teams,
            ground: ground,
            status: status,
            attendance: attendance,
            clock: clock,
            goals: goals
        )
    }
    
    func makeMatchTeam(team: Team, score: Int? = nil) -> MatchTeam {
        return MatchTeam(team: team, score: score)
    }
}

// MARK: - Configurable Mock Service

private final class ConfigurableMockMatchService: MatchService {
    private var matches: [Match] = []
    private var shouldFail = false
    
    func setMatches(_ matches: [Match]) {
        self.matches = matches
    }
    
    func setShouldFail(_ shouldFail: Bool) {
        self.shouldFail = shouldFail
    }
    
    func fetchMatches() async throws -> [Match] {
        if shouldFail {
            throw MockMatchService.MockError.simulatedFailure
        }
        return matches
    }
}