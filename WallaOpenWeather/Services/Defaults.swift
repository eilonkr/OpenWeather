//
//  Defaults.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import Foundation

struct Defaults {
    private static let defaults = UserDefaults.standard
    
    private struct Keys {
        static let prefersGrid = "prefersGrid"
        static let lastUpdated = "lastUpdated"
    }
    
    static var prefersGridUI: Bool {
        get {
            defaults.bool(forKey: Keys.prefersGrid)
        } set {
            defaults.set(newValue, forKey: Keys.prefersGrid)
        }
    }
    
    /// Represented in UNIX time (since 1970)
    static var lastUpdatedAt: TimeInterval {
        get {
            defaults.double(forKey: Keys.lastUpdated)
        } set {
            defaults.set(newValue, forKey: Keys.lastUpdated)
        }
    }
}
