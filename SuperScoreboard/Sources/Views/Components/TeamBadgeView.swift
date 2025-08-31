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
}

#Preview {
    HStack(spacing: 20) {
        TeamBadgeView(teamId: 1, abbreviation: "ARS")
        TeamBadgeView(teamId: 12, abbreviation: "MUN")
        TeamBadgeView(teamId: 999, abbreviation: "TST")
    }
    .padding()
}
