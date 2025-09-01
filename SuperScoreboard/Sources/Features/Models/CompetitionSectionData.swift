//
//  CompetitionSectionData.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import Domain

public struct CompetitionSectionData: Identifiable {
    public let id: String
    let competition: Competition?
    let title: String
    let matches: [MatchCardData]
    
    public init(competition: Competition?, title: String, matches: [MatchCardData]) {
        self.id = "\(competition?.id ?? 0)-\(title)"
        self.competition = competition
        self.title = title
        self.matches = matches
    }
}

extension CompetitionSectionData: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: CompetitionSectionData, rhs: CompetitionSectionData) -> Bool {
        lhs.id == rhs.id
    }
}
