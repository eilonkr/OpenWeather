//
//  Archiver.swift
//  BelongHomeOriject
//
//  Created by Eilon Krauthammer on 23/01/2020.
//  Copyright © 2020 Eilon Krauthammer. All rights reserved.
//

import Foundation

/// A service I wrote for saving data locally to the device's documents directory.
struct Archiver {
    enum Directory: String, CaseIterable {
        /// Variable.
        case weatherItems
        
        fileprivate var directoryURL: URL {
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(rawValue)
        }
    }
    
    private let directory: Directory
    
    public init(_ directory: Directory) {
        self.directory = directory
    }
    
    public func itemExists(forKey key: String) -> Bool {
        FileManager.default.fileExists(atPath:
            self.directory.directoryURL.appendingPathComponent(fn(key)).path)
    }
    
    /// Puts a single object.
    public func put<T: Encodable>(_ item: T, forKey key: String, inSubdirectory subdir: String? = nil) throws {
        if !FileManager.default.fileExists(atPath: directory.directoryURL.appendingPathComponent(subdir ?? directory.rawValue).path) {
            // Directory doesn't exist.
            try createDirectory(extension: subdir ?? directory.rawValue)
        }
        
        let data = try JSONEncoder().encode(item)
        let path = self.directory.directoryURL.appendingPathComponent(subdir ?? directory.rawValue).appendingPathComponent(fn(key))
        try data.write(to: path)
    }
    
    /// Puts an array of objects.
    public func put<T: Encodable & Identifiable>(_ arr: [T]) throws {
        for item in arr {
            try put(item, forKey: String(describing: item.id))
        }
    }

    public func get<T: Decodable>(itemForKey key: String, ofType _: T.Type) -> T? {
        let path = self.directory.directoryURL.appendingPathComponent(directory.rawValue).appendingPathComponent(fn(key))
        guard
            let data = try? Data(contentsOf: path),
            let object = try? JSONDecoder().decode(T.self, from: data)
        else { return .none }
        return object
    }
    
    /// Tries to fetch all available items in the directory of the given type.
    public func all<T: Decodable>(_: T.Type, pathExtension: String? = nil) throws -> [T]? {
        let contents = try FileManager.default.contentsOfDirectory(at: directory.directoryURL.appendingPathComponent(pathExtension ?? directory.rawValue), includingPropertiesForKeys: nil, options: [])
        
        var entries = [T]()
        for file in contents {
            let data = try Data(contentsOf: file)
            let object = try JSONDecoder().decode(T.self, from: data)
            entries.append(object)
        }
        
        return entries
    }
    
    public func deleteItem(forKey key: String) throws {
        let url = self.directory.directoryURL.appendingPathComponent(directory.rawValue).appendingPathComponent(fn(key))
        if FileManager.default.fileExists(atPath: url.path) {
            try FileManager.default.removeItem(at: url)
        }
    }
    
    public func deleteAll(extension ext: String? = nil) throws {
        let url = directory.directoryURL.appendingPathComponent(ext ?? directory.rawValue)
        try FileManager.default.removeItem(at: url)
    }
    
    /// File name without extensions
    private func fn(_ key: String) -> String {
        key.filter { $0 != "." }
    }
    
    private func createDirectory(extension ext: String? = nil) throws {
        try FileManager.default.createDirectory(atPath: directory.directoryURL.appendingPathComponent(ext ?? "").path, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// Clears all archives from all directories.
    static func clearAllCache() throws {
        for path in Directory.allCases {
            try Self(path).deleteAll()
        }
    }
    
}
