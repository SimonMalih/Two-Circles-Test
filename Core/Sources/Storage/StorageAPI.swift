//
//  StorageAPI.swift
//  Core
//
//  Created by Simon Malih on 01/09/2025.
//

/// Protocol for type-safe key-value storage operations with Codable support.
public protocol StorageAPI: Sendable {
    
    func save<T: Codable>(_ value: T, forKey key: String) throws
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) throws -> T?
    
    func exists(forKey key: String) -> Bool
    
    func remove(forKey key: String)
}
