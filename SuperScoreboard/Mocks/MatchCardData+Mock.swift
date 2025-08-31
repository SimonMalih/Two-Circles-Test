//
//  MatchCardData+Mock.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 30/08/2025.
//

import Domain

extension MatchCardData {
    static let upcoming = MatchCardData(
        homeTeam: .liverpool,
        awayTeam: .arsenal,
        homeScore: "1",
        awayScore: "2",
        homeTeamAbbr: Team.liverpool.shortName,
        awayTeamAbbr: Team.arsenal.shortName,
        shouldShowScores: false,
        match: .upcoming
    )
    
    static let live = MatchCardData(
        homeTeam: .manUtd,
        awayTeam: .newcastle,
        homeScore: "2",
        awayScore: "1",
        homeTeamAbbr: Team.manUtd.shortName,
        awayTeamAbbr: Team.newcastle.shortName,
        shouldShowScores: true,
        match: .live
    )
    
    static let completed = MatchCardData(
        homeTeam: .westHam,
        awayTeam: .brighton,
        homeScore: "1",
        awayScore: "3",
        homeTeamAbbr: Team.westHam.shortName,
        awayTeamAbbr: Team.brighton.shortName,
        shouldShowScores: true,
        match: .completed
    )
}