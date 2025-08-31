//
//  MatchCardView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 30/08/2025.
//

import SwiftUI
import Domain

struct MatchCardView: View {
    let matchData: MatchCardData
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            homeTeamSection
            centerSection
            awayTeamSection
        }
        .padding(16)
        .frame(height: 96)
        .background(.surfaceBase)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var homeTeamSection: some View {
        HStack(spacing: 12) {
            TeamBadgeView(
                teamId: matchData.homeTeamId,
                abbreviation: matchData.homeTeamAbbr
            )
            Spacer()
            if matchData.shouldShowScores {
                Text(matchData.homeScore)
                    .customFont(.headingsLarge)
            } else {
                Text(matchData.homeTeamAbbr)
                    .customFont(.headingTitle3)
            }
        }
    }
    
    private var centerSection: some View {
        MatchTimeIndicatorView(match: matchData.match)
            .padding(.horizontal, 11)
    }
    
    private var awayTeamSection: some View {
        HStack(spacing: 12) {
            if matchData.shouldShowScores {
                Text(matchData.awayScore)
                    .customFont(.headingsLarge)
            } else {
                Text(matchData.awayTeamAbbr)
                    .customFont(.headingTitle3)
            }
            Spacer()
            TeamBadgeView(
                teamId: matchData.awayTeamId,
                abbreviation: matchData.awayTeamAbbr
            )
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        MatchCardView(matchData: .upcoming)
        MatchCardView(matchData: .live)
        MatchCardView(matchData: .completed)
    }
    .addFullscreenBackground()
}
