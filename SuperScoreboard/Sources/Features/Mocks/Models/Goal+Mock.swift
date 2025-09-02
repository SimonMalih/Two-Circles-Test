//
//  Goal+Mock.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import Domain

extension Goal {
    static let regularGoal = Goal(
        personId: 12345,
        assistId: 67890,
        clock: .goalTime15,
        phase: "1",
        type: "G",
        description: "G"
    )
    
    static let penaltyGoal = Goal(
        personId: 54321,
        assistId: nil,
        clock: .goalTime67,
        phase: "2",
        type: "P",
        description: "P"
    )
    
    static let assistedGoal = Goal(
        personId: 11111,
        assistId: 22222,
        clock: .goalTime43,
        phase: "1",
        type: "G",
        description: "G"
    )
    
    static let earlyGoal = Goal(
        personId: 33333,
        assistId: nil,
        clock: .goalTime2,
        phase: "1",
        type: "G",
        description: "G"
    )
    
    static let lateGoal = Goal(
        personId: 44444,
        assistId: 55555,
        clock: .goalTime90Plus3,
        phase: "2",
        type: "G",
        description: "G"
    )
    
    static let lateFirstHalfGoal = Goal(
        personId: 77777,
        assistId: 88888,
        clock: .goalTime43,
        phase: "1",
        type: "G",
        description: "G"
    )
    
    static let matchGoals = [regularGoal, penaltyGoal, assistedGoal]
    static let multipleGoals = [earlyGoal, regularGoal, assistedGoal, penaltyGoal, lateGoal]
}