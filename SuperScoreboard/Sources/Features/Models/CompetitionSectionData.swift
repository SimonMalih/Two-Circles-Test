//
//  CompetitionSectionData.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import Domain

public struct CompetitionSectionData {
    let competition: Competition?
    let title: String
    let matches: [MatchCardData]
}
