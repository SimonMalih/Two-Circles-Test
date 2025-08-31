//
//  CompetitionSectionView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 30/08/2025.
//

import SwiftUI
import Domain

struct CompetitionSectionView: View {
    let sectionData: CompetitionSectionData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CompetitionHeaderView(competitionId: sectionData.competition?.id ?? 0, title: sectionData.title)
            ForEach(sectionData.matches, id: \.match.id) { matchData in
                MatchCardView(matchData: matchData)
            }
        }
        .padding(.vertical, 16)
    }
}

#Preview {
    CompetitionSectionView(
        sectionData: CompetitionSectionData(
            competition: Competition(id: 1, title: "Premier League"),
            title: "Premier League",
            matches: MatchCardData.premierLeagueMatches
        )
    )
    .addFullscreenBackground()
}
