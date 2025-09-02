//
//  Clock+Mock.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 30/08/2025.
//

import Domain

extension Clock {
    static let firstHalf = Clock(secs: 720, label: "12'")
    static let secondHalf = Clock(secs: 2700, label: "45'")
    static let fullTime = Clock(secs: 5400, label: "FT")
    
    // Goal timing clocks
    static let goalTime2 = Clock(secs: 120, label: "02'00")
    static let goalTime15 = Clock(secs: 900, label: "15'00")
    static let goalTime43 = Clock(secs: 2580, label: "43'00")
    static let goalTime67 = Clock(secs: 4020, label: "67'00")
    static let goalTime90Plus3 = Clock(secs: 5580, label: "90 +3'00")
}