import Foundation

public enum MockError: Error {
    case simulatedFailure
}

/// Simple mock MatchService implementation for testing
public final class MockMatchService: MatchService {

    private let matches: [Match]
    private let shouldFail: Bool
    
    public init(matches: [Match] = [], shouldFail: Bool = false) {
        self.matches = matches
        self.shouldFail = shouldFail
    }
    
    public func fetchMatches() async throws -> [Match] {
        if shouldFail {
            throw MockError.simulatedFailure
        }
        return matches
    }
}
