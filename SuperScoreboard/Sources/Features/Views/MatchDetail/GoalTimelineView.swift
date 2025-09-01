//
//  GoalTimelineView.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import SwiftUI
import Domain

struct GoalTimelineView: View {
    let goals: [Goal]
    
    private var sortedGoals: [Goal] {
        goals.sorted { $0.clock.secs < $1.clock.secs }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(sortedGoals, id: \.personId) { goal in
                GoalEventRowView(goal: goal)
                
                if goal != sortedGoals.last {
                    Divider()
                        .padding(.horizontal, 16)
                }
            }
        }
        .padding(.bottom, 16)
    }
}

#Preview("Multiple Goals") {
    VStack {
        GoalTimelineView(goals: [.regularGoal, .penaltyGoal, .assistedGoal])
            .background(.surfaceBase)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .addFullscreenBackground()
}

#Preview("Single Goal") {
    VStack {
        GoalTimelineView(goals: [.regularGoal])
            .background(.surfaceBase)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .addFullscreenBackground()
}
