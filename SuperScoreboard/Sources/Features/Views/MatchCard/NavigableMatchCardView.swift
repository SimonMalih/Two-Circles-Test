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
