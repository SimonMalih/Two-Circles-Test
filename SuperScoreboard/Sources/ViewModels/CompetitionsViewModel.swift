import Observation
import Domain

@Observable
final class CompetitionsViewModel {
    
    private var matches: [Match] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var sectionsData: [CompetitionSectionData] = []
    
    func fetchMatches() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // TODO: add support for mocking
            matches = try await DataSourceFactory.matchesDataSource().execute()
            sectionsData = calculateSectionsData(from: matches)
        } catch {
            errorMessage = "Failed to load matches: \(error.localizedDescription)"
            matches = []
            sectionsData = []
        }
        
        isLoading = false
    }
    
    private func calculateSectionsData(from matches: [Match]) -> [CompetitionSectionData] {
        let validMatches = matches.filter { $0.teams.count >= 2 }
        
        let groupedByCompetition = Dictionary(grouping: validMatches) { match in
            match.competition?.title ?? "Other"
        }
        
        var sections: [CompetitionSectionData] = []
        for title in groupedByCompetition.keys.sorted() {
            guard let matchesInCompetition = groupedByCompetition[title] else { continue }
            
            // Get the competition object from the first match in this group
            let competition = matchesInCompetition.first?.competition
            
            let matchCardDataArray = matchesInCompetition.compactMap { match -> MatchCardData? in
                guard match.teams.count >= 2 else { return nil }
                
                let homeTeam = match.teams[0]
                let awayTeam = match.teams[1]
                
                return MatchCardData(
                    homeTeam: homeTeam,
                    awayTeam: awayTeam,
                    homeScore: String(homeTeam.score ?? 0),
                    awayScore: String(awayTeam.score ?? 0),
                    homeTeamAbbr: homeTeam.team.club.abbr,
                    awayTeamAbbr: awayTeam.team.club.abbr,
                    shouldShowScores: match.status.shouldShowScores,
                    match: match
                )
            }
            
            guard !matchCardDataArray.isEmpty else { continue }
            sections.append(CompetitionSectionData(competition: competition, title: title, matches: matchCardDataArray))
        }
        return sections
    }

}
