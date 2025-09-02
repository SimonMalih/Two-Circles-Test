//
//  MatchTimeIndicatorView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 30/08/2025.
//

import SwiftUI
import Domain

// Displays match time - live clock or kickoff time
// TODO: show maybe the date of completed match like 05/04 or 16/10/24
struct MatchTimeIndicatorView: View {
    let match: Match
    
    var body: some View {
        if match.status.isLive {
            // Live match - show clock with red background
            Text(match.clock?.label ?? "live")
                .styleScoreTime(true)
                .accessibilityAddTraits(.updatesFrequently)
                .accessibilityLabel(Text("accessibility_live_status".localizedKey(with: match.clock?.label ?? "live".localized)))
        } else {
            // Upcoming or Completed match - show kickoff time
            Text(match.kickoff.millis.formattedKickoffTime)
                .styleScoreTime(false)
                .accessibilityLabel(Text(match.status == .completed ? "accessibility_full_time".localized : "accessibility_kickoff_time".localizedKey(with: match.kickoff.millis.formattedKickoffTime)))
        }
    }
}

private extension View {
    func styleScoreTime(_ isLive: Bool) -> some View {
        self
            .customFont(.caption1Regular, color: isLive ? .textIconDefaultWhite : .textIconDefaultBlack)
            .frame(width: 48, height: 24)
            .background(isLive ? .red75 : .fillPrimary)
            .clipShape(RoundedRectangle(cornerRadius: .cornerRadius))
    }
}

#Preview {
    VStack(spacing: 20) {
        MatchTimeIndicatorView(match: .upcoming)
        MatchTimeIndicatorView(match: .live)
        MatchTimeIndicatorView(match: .completed)
    }
    .addFullscreenBackground()
}
