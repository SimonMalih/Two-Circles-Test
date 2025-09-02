//
//  CompetitionHeaderView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 30/08/2025.
//

import SwiftUI

struct CompetitionHeaderView: View {
    let competitionId: Int
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            CompetitionBadgeView(competitionId: competitionId, title: title)
            Text(title)
                .customFont(.bodyMedium, color: .textIconDefaultBlack)
            Spacer()
            Image("chevron")
                .frame(width: 24, height: 24)
        }
        .padding(.vertical, 6)
        .accessibilityIdentifier("competition_header_\(competitionId)")
    }
}

#Preview {
    VStack(spacing: 20) {
        CompetitionHeaderView(competitionId: 2, title: "Champions League")
        CompetitionHeaderView(competitionId: 1, title: "Premier League")
        CompetitionHeaderView(competitionId: 3, title: "La Liga")
    }
    .addFullscreenBackground()
}
