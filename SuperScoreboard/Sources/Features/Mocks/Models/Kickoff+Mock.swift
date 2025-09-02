//
//  Kickoff+Mock.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 30/08/2025.
//

import Foundation
import Domain

extension Kickoff {
    static let upcoming = Kickoff(
        completeness: 3,
        millis: .upcomingMatchKickoff,
        label: "20:00"
    )
    
    static let live = Kickoff(
        completeness: 3,
        millis: .liveMatchKickoff,
        label: ""
    )
    
    static let completed = Kickoff(
        completeness: 3,
        millis: .completedMatchKickoff,
        label: ""
    )
}