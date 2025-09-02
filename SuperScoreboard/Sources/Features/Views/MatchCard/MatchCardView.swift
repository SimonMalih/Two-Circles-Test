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
    let favoritesRepository: FavouritesRepositoryProtocol?
    
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
        .accessibilityElement(children: .ignore)
    }
    
    private var homeTeamSection: some View {
        HStack(spacing: 12) {
            TeamBadgeView(
                teamId: matchData.homeTeamId,
                abbreviation: matchData.homeTeamAbbr,
                isFavorite: isHomeTeamFavorite
            )
            Spacer()
            if matchData.shouldShowScores {
                Text(matchData.homeScore)
                    .scoreStyle()
                
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
                    .scoreStyle()
            } else {
                Text(matchData.awayTeamAbbr)
                    .customFont(.headingTitle3)
            }
            Spacer()
            TeamBadgeView(
                teamId: matchData.awayTeamId,
                abbreviation: matchData.awayTeamAbbr,
                isFavorite: isAwayTeamFavorite
            )
        }
    }
}

private extension MatchCardView {
    
    var isHomeTeamFavorite: Bool {
        favoritesRepository?.isFavorite(clubId: matchData.homeTeamId) ?? false
    }
    
    var isAwayTeamFavorite: Bool {
        favoritesRepository?.isFavorite(clubId: matchData.awayTeamId) ?? false
    }
}

extension Text {
    
    func scoreStyle() -> some View {
        self
            .customFont(.headingsLarge)
            .scaleEffect(x: 1, y: 0.6, anchor: .center)
    }
}

#Preview {
    VStack(spacing: 16) {
        MatchCardView(matchData: .upcoming, favoritesRepository: nil)
        MatchCardView(matchData: .live, favoritesRepository: nil)
        MatchCardView(matchData: .completed, favoritesRepository: nil)
    }
    .addFullscreenBackground()
}
