//
//  MockMatchService+Preview.swift
//  SuperScoreboard
//
//  Created by Simon Malih on 31/08/2025.
//

import Domain

public extension MockMatchService {
    
    enum MockState {
        case loaded
        case empty
        case error
    }
    
    // MARK: - Preview Instances
    
    static let loaded = MockMatchService(matches: MockMatchData.matches)
    static let empty = MockMatchService(matches: [])
    static let error = MockMatchService(matches: [], shouldFail: true)
    
    // MARK: - Convenience Factory Methods
    
    static func service(for state: MockState) -> MockMatchService {
        switch state {
        case .loaded:
            return .loaded
        case .empty:
            return .empty
        case .error:
            return .error
        }
    }
}