//
//  UserDefaultsStorageAPI.swift
//  Core
//
//  Created by Simon Malih on 01/09/2025.
//

import Foundation

/// UserDefaults-backed storage with JSON encoding for Codable types.
public final class UserDefaultsStorageAPI: Sendable, StorageAPI {
    private let userDefaults: UserDefaultsWrapper
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = UserDefaultsWrapper(defaults: userDefaults)
    }
    
    public func save<T: Codable>(_ value: T, forKey key: String) throws {
        let data = try encoder.encode(value)
        userDefaults.set(data, forKey: key)
    }
    
    public func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try decoder.decode(type, from: data)
    }
    
    public func exists(forKey key: String) -> Bool {
        userDefaults.object(forKey: key) != nil
    }
    
    public func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
