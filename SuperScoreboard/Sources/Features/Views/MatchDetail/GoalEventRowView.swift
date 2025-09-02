//
//  GoalEventRowView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 01/09/2025.
//

import SwiftUI
import Domain

struct GoalEventRowView: View {
    let goal: Goal
    
    var body: some View {
        HStack(spacing: 12) {
            goalTypeIcon
                
            playerInfoView
            Spacer()
            goalTimeView
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
    
    private var playerInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text("player_label".localizedKey(with: goal.personId))
                    .customFont(.headingTitle3)
                    .foregroundColor(.primary)
                
                if goal.type == "P" {
                    penaltyLabelView
                }
            }
            
            if let assistId = goal.assistId {
                assistInfoView(assistId: assistId)
            }
            
            matchPhaseBadgeView
        }
    }
    
    private var penaltyLabelView: some View {
        Text("penalty_label")
            .customFont(.captionMedium)
            .foregroundColor(.orange)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(.orange.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    private func assistInfoView(assistId: Int) -> some View {
        Text("assist_player_label".localizedKey(with: assistId))
            .customFont(.bodySmall)
            .foregroundColor(.secondary)
    }
    
    private var matchPhaseBadgeView: some View {
        Text(matchPhaseDescription)
            .customFont(.captionMedium)
            .foregroundColor(.secondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    private var goalTimeView: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(goal.clock.label)
                .customFont(.headingTitle2)
                .foregroundColor(.primary)
                .fontWeight(.bold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.primary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var goalTypeIcon: some View {
        VStack {
            if goal.type == "P" {
                Image(systemName: "p.circle.fill")
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(.orange)
                            .frame(width: 28, height: 28)
                    )
            } else {
                Image(systemName: "soccerball.inverse")
                    .foregroundColor(.white)
                    .background {
                        Circle()
                            .fill(.green)
                            .frame(width: 28, height: 28)
                    }
            }
        }
        .frame(width: 28, height: 28)
    }
    
    private var matchPhaseDescription: LocalizedStringKey {
        switch goal.phase {
        case "1":
            "first_half"
        case "2":
            "second_half"
        default:
            "unknown_phase"
        }
    }
}

#Preview {
    GoalEventRowView(goal: .regularGoal)
}
