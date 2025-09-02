import Foundation

public enum MockStorageError: Error {
    case simulatedFailure
}

/// Simple mock StorageAPI implementation using a dictionary for testing.
public final class MockStorageAPI: StorageAPI {
        
    private var storage: [String: Any]
    public var shouldFail: Bool
    
    public var onSave: ((any Codable, String) throws -> Void)?
    public var onLoad: ((String) throws -> (any Codable)?)?
    
    public init(
        initialData: [String: any Codable] = [:],
        shouldFail: Bool = false
    ) {
        self.storage = initialData
        self.shouldFail = shouldFail
    }
    
    public func save<T: Codable>(_ value: T, forKey key: String) throws {
        try maybeThrow()
        
        try onSave?(value, key)
        
        storage[key] = value
    }
    
    public func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
        try maybeThrow()
        
        _ = try onLoad?(key)
        
        return storage[key] as? T
    }
    
    public func exists(forKey key: String) -> Bool {
        storage[key] != nil
    }
    
    public func remove(forKey key: String) {
        storage.removeValue(forKey: key)
    }
}

// MARK: - Private Helper Methods

private extension MockStorageAPI {
    func maybeThrow() throws {
        if shouldFail {
            throw MockStorageError.simulatedFailure
        }
    }
}

// MARK: - Test Helper Methods

extension MockStorageAPI {
    
    public func setState(_ data: [String: any Codable]) {
        storage = data
    }
    
    public func reset() {
        storage.removeAll()
        shouldFail = false
        onSave = nil
        onLoad = nil
    }
}
