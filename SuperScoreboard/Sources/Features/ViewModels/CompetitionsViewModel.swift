//
//  CompetitionsViewModel.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import Observation
import Domain

@Observable
final class CompetitionsViewModel {
    
    var matches: [Match] = []
    var viewState: ViewState = .loading
    var sectionsData: [CompetitionSectionData] = []
    
    @MainActor
    func fetchMatches() async {
        viewState = .loading
        
        do {
            // TODO: add support for mocking
            matches = try await DataSourceFactory.matchesDataSource().execute()
            sectionsData = calculateSectionsData(from: matches)
            
            viewState = sectionsData.isEmpty ? .empty : .loaded
        } catch {
            viewState = .error
            matches = []
            sectionsData = []
        }
    }
}

// MARK: - Data Filtering and Transformation

private extension CompetitionsViewModel {
    private func calculateSectionsData(from matches: [Match]) -> [CompetitionSectionData] {
        let validMatches = matches.filter { $0.teams.count >= 2 }
        let groupedMatches = Dictionary(grouping: validMatches) { match in
            match.competition?.title ?? "Other"
        }
        return createCompetitionSections(from: groupedMatches)
    }
    
    private func createMatchCardData(from match: Match) -> MatchCardData? {
        guard match.teams.count >= 2 else { return nil }
        
        let homeTeam = match.teams[0]
        let awayTeam = match.teams[1]
        
        return MatchCardData(
            homeTeam: homeTeam,
            awayTeam: awayTeam,
            homeScore: String(homeTeam.score ?? 0),
            awayScore: String(awayTeam.score ?? 0),
            shouldShowScores: match.status.shouldShowScores,
            match: match
        )
    }
    
    private func createCompetitionSection(title: String, matches: [Match]) -> CompetitionSectionData? {
        let competition = matches.first?.competition
        let matchCardDataArray = matches.compactMap { createMatchCardData(from: $0) }
        
        guard !matchCardDataArray.isEmpty else { return nil }
        
        return CompetitionSectionData(
            competition: competition,
            title: title,
            matches: matchCardDataArray
        )
    }
    
    private func createCompetitionSections(from groupedMatches: [String: [Match]]) -> [CompetitionSectionData] {
        return groupedMatches.keys.sorted().compactMap { title in
            guard let matchesInCompetition = groupedMatches[title] else { return nil }
            return createCompetitionSection(title: title, matches: matchesInCompetition)
        }
    }
}
