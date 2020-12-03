//
//  Defaults.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import Foundation

@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        } set {
            container.set(newValue, forKey: key)
        }
    }
}


struct Defaults {
    enum Keys: String {
        case prefersGrid
        case lastUpdated
    }
    
    @UserDefault(key: Keys.prefersGrid.rawValue, defaultValue: false)
    static var prefersGridUI: Bool
    
    @UserDefault(key: Keys.lastUpdated.rawValue, defaultValue: 0)
    static var lastUpdatedAt: TimeInterval
}
