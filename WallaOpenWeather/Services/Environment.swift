//
//  Environment.swift
//
//  Created by Eilon Krauthammer on 18/11/2020.
//

import Foundation

struct Environment {
    struct Secrets {
        static let WEATHER_API_KEY = "4551c26e3dc97bd43b85434eaa45af10"
    }
    
    static var isDebug: Bool {
        getEnvironmentValue(forKey: "is_debug") == "true"
    }
    
    /// Retrieves a scheme evnironment object for the given key.
    fileprivate static func getEnvironmentValue(forKey key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }
}

