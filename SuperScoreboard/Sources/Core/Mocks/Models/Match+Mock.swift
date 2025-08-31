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
        attendance: nil,
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
        attendance: nil,
        clock: .firstHalf,
        goals: nil
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
        goals: nil
    )
    
    static let premierLeagueMatches = [upcoming, live, completed]
    static let championsLeagueMatches: [Match] = []
    static let allMatches = [upcoming, live, completed]
    static let previewMatches = [upcoming, live, completed]
}