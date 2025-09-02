//
//  MockDataSource.swift
//  Domain
//
//  Created by Simon Malih on 02/09/2025.
//

import Core

final class MockDataSource<T>: DataSource {
    private let result: Result<T, Error>
    private(set) var executeCallCount = 0
    
    init(result: Result<T, Error>) {
        self.result = result
    }
    
    func execute() async throws -> T {
        executeCallCount += 1
        switch result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
