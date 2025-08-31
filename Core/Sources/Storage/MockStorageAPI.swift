import Foundation

/// Simple mock StorageAPI implementation using a dictionary for testing.
public final class MockStorageAPI: StorageAPI {
    
    public enum MockStorageError: Error {
        case simulatedFailure
    }
    
    private var storage: [String: Codable]
    private var shouldFail: Bool
    
    public init(storage: [String: Codable] = [:], shouldFail: Bool = false) {
        self.storage = storage
        self.shouldFail = shouldFail
    }
    
    public func save<T: Codable>(_ value: T, forKey key: String) throws {
        try maybeThrow()
        storage[key] = value
    }
    
    public func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
        try maybeThrow()
        return storage[key] as? T
    }
    
    public func exists(forKey key: String) -> Bool {
        storage[key] != nil
    }
    
    public func remove(forKey key: String) {
        storage.removeValue(forKey: key)
    }
}
extension MockStorageAPI {
    // MARK: - Test Helper Methods
    
    public func setError(_ shouldFail: Bool) {
        self.shouldFail = shouldFail
    }
    
    public func setState(_ data: [String: Codable]) {
        storage = data
    }
    
    public func reset() {
        storage.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func maybeThrow() throws {
        if shouldFail {
            throw MockStorageError.simulatedFailure
        }
    }
}
