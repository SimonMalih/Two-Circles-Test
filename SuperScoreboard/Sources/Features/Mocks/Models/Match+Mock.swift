//
//  Match+Mock.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 30/08/2025.
//

import Domain

extension Match {
    static let upcoming = Match(
        id: 1,
        kickoff: .upcoming,
        competition: .premierLeague,
        teams: [.liverpool, .arsenal],
        ground: .emirates,
        status: .upcoming,
        attendance: 60704,
        clock: nil,
        goals: nil
    )
    
    static let live = Match(
        id: 2,
        kickoff: .live,
        competition: .premierLeague,
        teams: [.manUtd, .newcastle],
        ground: .oldTrafford,
        status: .inProgress,
        attendance: 74310,
        clock: .firstHalf,
        goals: [.earlyGoal, .lateFirstHalfGoal]
    )
    
    static let completed = Match(
        id: 3,
        kickoff: .completed,
        competition: .premierLeague,
        teams: [.westHam, .brighton],
        ground: .emirates,
        status: .completed,
        attendance: 40000,
        clock: .fullTime,
        goals: [.regularGoal, .penaltyGoal, .assistedGoal]
    )
    
    static let premierLeagueMatches = [upcoming, live, completed]
    static let championsLeagueMatches: [Match] = []
    static let allMatches = [upcoming, live, completed]
    static let previewMatches = [upcoming, live, completed]
}