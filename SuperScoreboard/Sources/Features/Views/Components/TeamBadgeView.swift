//
//  TeamBadgeView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 30/08/2025.
//

import SwiftUI

// Assets from https://github.com/luukhopman/football-logos/tree/master/history/2023-24

struct TeamBadgeView: View {
    
    let teamId: Int
    let abbreviation: String
    let isFavorite: Bool
    
    private let clubLogos: [Int: String] = [
        1: "Arsenal",
        8: "Ipswich Town",
        10: "Liverpool",
        12: "Manchester United",
        15: "Nottingham Forest",
        20: "Southampton",
        23: "Newcastle United",
        25: "West Ham United",
        127: "Bournemouth",
        131: "Brighton and Hove Albion"
    ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let logoName = clubLogos[teamId] {
                    Image(logoName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                } else {
                    fallbackBadge
                }
            }
            .padding(.trailing, 5)
            
            if isFavorite {
                followBadge
            }
        }
    }
    
    private var fallbackBadge: some View {
        Circle()
            .fill(.fillPrimary)
            .frame(width: 30, height: 40)
            .overlay {
                Text(abbreviation)
                    .customFont(.clubBadgeFallback)
            }
    }
    
    
    private var followBadge: some View {
        Image("FollowBadge")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
    }
}

#Preview {
    HStack(spacing: 20) {
        TeamBadgeView(teamId: 1, abbreviation: "ARS", isFavorite: true)
        TeamBadgeView(teamId: 10, abbreviation: "LIV", isFavorite: true)
        TeamBadgeView(teamId: 12, abbreviation: "MUN", isFavorite: false)
    }
    .padding()
    .addFullscreenBackground()
}
