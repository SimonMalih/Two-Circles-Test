import Foundation
import Core

/// Concrete implementation of MatchService that fetches matches from a remote API
public final class RemoteMatchService: MatchService {
    
    private let dataSource: any DataSource<[Match]>
    
    public init(dataSource: any DataSource<[Match]>) {
        self.dataSource = dataSource
    }
    
    public func fetchMatches() async throws -> [Match] {
        try await dataSource.execute()
    }
}
