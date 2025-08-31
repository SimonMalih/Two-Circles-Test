//
//  MatchCardData.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import Domain

public struct MatchCardData {
    let homeTeam: MatchTeam
    let awayTeam: MatchTeam
    let homeScore: String
    let awayScore: String
    let shouldShowScores: Bool
    let match: Match
        
    var homeTeamAbbr: String {
        homeTeam.team.club.abbr
    }
    
    var awayTeamAbbr: String {
        awayTeam.team.club.abbr
    }
    
    var homeTeamId: Int {
        homeTeam.team.id
    }
    
    var awayTeamId: Int {
        awayTeam.team.id
    }
}
