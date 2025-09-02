//
//  NavigableMatchCardView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI
import Domain

struct NavigableMatchCardView: View {
    
    @State private var showMatchDetail = false
    let matchData: MatchCardData
    let favoritesRepository: FavouritesRepositoryProtocol?
    
    var body: some View {
        Button {
            showMatchDetail = true
        } label: {
            MatchCardView(matchData: matchData, favoritesRepository: favoritesRepository)
                .contentShape(Rectangle())
                .navigationDestination(isPresented: $showMatchDetail) {
                    MatchDetailView(match: matchData.match, favoritesRepository: favoritesRepository)
                }
        }
        .accessibilityLabel(Text(accessibilityLabel))
        .accessibilityHint(Text("accessibility_match_card_hint"))
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(named: Text("accessibility_match_details_action")) {
            showMatchDetail = true
        }
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: String {
        let homeTeam = matchData.homeTeamAbbr
        let awayTeam = matchData.awayTeamAbbr
        
        if matchData.shouldShowScores {
            let homeScore = matchData.homeScore
            let awayScore = matchData.awayScore
            let status = matchData.match.status.isLive ? matchData.match.clock?.label ?? "live".localized : "match_status_full_time".localized
            return "accessibility_match_card".localizedKey(arguments: homeTeam, awayTeam, "accessibility_score_live".localizedKey(arguments: homeScore, awayScore, status), status)
        } else {
            let kickoffTime = matchData.match.kickoff.millis.formattedKickoffTime
            return "accessibility_match_card".localizedKey(arguments: homeTeam, awayTeam, "accessibility_score_upcoming".localizedKey(with: kickoffTime), "match_status_upcoming".localized)
        }
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 16) {
            NavigableMatchCardView(matchData: .upcoming, favoritesRepository: nil)
            NavigableMatchCardView(matchData: .live, favoritesRepository: nil)
            NavigableMatchCardView(matchData: .completed, favoritesRepository: nil)
        }
        .addFullscreenBackground()
    }
}
