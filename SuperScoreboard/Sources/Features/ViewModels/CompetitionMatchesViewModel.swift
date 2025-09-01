//
//  CompetitionMatchesViewModel.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 01/09/2025.
//

import Observation
import Domain

@Observable
final class CompetitionMatchesViewModel {
    
    let competition: Competition?
    let competitionTitle: String
    var matches: [MatchCardData]
    let favoritesRepository: FavouritesRepositoryProtocol
    
    init(
        competition: Competition?,
        competitionTitle: String,
        matches: [MatchCardData],
        favoritesRepository: FavouritesRepositoryProtocol
    ) {
        self.competition = competition
        self.competitionTitle = competitionTitle
        self.matches = matches
        self.favoritesRepository = favoritesRepository
    }
}
