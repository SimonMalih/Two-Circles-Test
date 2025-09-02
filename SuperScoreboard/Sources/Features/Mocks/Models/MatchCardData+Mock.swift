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
        shouldShowScores: false,
        match: .upcoming
    )
    
    static let live = MatchCardData(
        homeTeam: .manUtd,
        awayTeam: .newcastle,
        homeScore: "2",
        awayScore: "1",
        shouldShowScores: true,
        match: .live
    )
    
    static let completed = MatchCardData(
        homeTeam: .westHam,
        awayTeam: .brighton,
        homeScore: "1",
        awayScore: "3",
        shouldShowScores: true,
        match: .completed
    )
    
    static let premierLeagueMatches: [MatchCardData] = [
        MatchCardData(
            homeTeam: .arsenal,
            awayTeam: .liverpool,
            homeScore: "2",
            awayScore: "1",
            shouldShowScores: true,
            match: .completed
        ),
        MatchCardData(
            homeTeam: .manUtd,
            awayTeam: .brighton,
            homeScore: "1",
            awayScore: "1",
            shouldShowScores: true,
            match: .live
        ),
        MatchCardData(
            homeTeam: .newcastle,
            awayTeam: .westHam,
            homeScore: "0",
            awayScore: "0",
            shouldShowScores: false,
            match: .upcoming
        ),
        MatchCardData(
            homeTeam: .southampton,
            awayTeam: .nottinghamForest,
            homeScore: "0",
            awayScore: "2",
            shouldShowScores: true,
            match: .completed
        ),
        MatchCardData(
            homeTeam: .bournemouth,
            awayTeam: .ipswichTown,
            homeScore: "3",
            awayScore: "1",
            shouldShowScores: true,
            match: .completed
        )
    ]
}
