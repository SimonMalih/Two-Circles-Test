//
//  UserDefaultsWrapper.swift
//  Core
//
//  Created by Simon Malih on 01/09/2025.
//

import Foundation

/// A Sendable wrapper around UserDefaults.
/// UserDefaults is thread-safe according to Apple's documentation, but doesn't conform to Sendable.
/// This wrapper provides a Sendable interface while maintaining the same functionality.
public final class UserDefaultsWrapper: @unchecked Sendable {
    private let defaults: UserDefaults
    
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    public func set(_ value: Any?, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    public func data(forKey key: String) -> Data? {
        defaults.data(forKey: key)
    }
    
    public func object(forKey key: String) -> Any? {
        defaults.object(forKey: key)
    }
    
    public func string(forKey key: String) -> String? {
        defaults.string(forKey: key)
    }
    
    public func removeObject(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}
