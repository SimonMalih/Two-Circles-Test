//
//  CompetitionBadgeView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI

struct CompetitionBadgeView: View {
    let competitionId: Int
    let title: String
    
    private let competitionLogos: [Int: String] = [
        1: "Premier League",
        2: "Champions League"
    ]
    
    var body: some View {
        Group {
            if let logoName = competitionLogos[competitionId] {
                Image(logoName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            } else {
                fallbackBadge
            }
        }
    }
    
    private var fallbackBadge: some View {
        Circle()
            .fill(Color(.systemGray5))
            .frame(width: 24, height: 24)
            .overlay {
                Text(String(title.first?.uppercased() ?? ""))
                    .customFont(.clubBadgeFallback)
            }
    }
}

#Preview {
    HStack(spacing: 20) {
        CompetitionBadgeView(competitionId: 1, title: "Premier League")
        CompetitionBadgeView(competitionId: 2, title: "Champions League")
        CompetitionBadgeView(competitionId: 999, title: "Test Competition")
        CompetitionBadgeView(competitionId: 888, title: "La Liga")
    }
    .padding()
}
