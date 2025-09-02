//
//  CompetitionMatchesView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 01/09/2025.
//

import SwiftUI
import Domain

struct CompetitionMatchesView: View {
    
    let viewModel: CompetitionMatchesViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 8) {
                // Matches list
                ForEach(viewModel.matches, id: \.match.id) { matchData in
                    NavigableMatchCardView(
                        matchData: matchData,
                        favoritesRepository: viewModel.favoritesRepository
                    )
                }
            }
            .padding(.vertical, 16)
        }
        .padding(.horizontal, 16)
        .addBackground()
        .navBarTitle(LocalizedStringKey(viewModel.competitionTitle))
    }
}

#Preview {
    NavigationStack {
        CompetitionMatchesView(
            viewModel: CompetitionMatchesViewModel(
                competition: Competition(id: 1, title: "Premier League"),
                competitionTitle: "Premier League",
                matches: MatchCardData.premierLeagueMatches,
                favoritesRepository: MockFavouritesRepository.preview
            )
        )
    }
}
