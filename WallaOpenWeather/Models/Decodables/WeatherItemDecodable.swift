//
//  WeatherDecodable.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import Foundation

struct WeatherItemDecodable: Decodable {
    struct Weather: Decodable {
        let main: String
        let icon: String
    }
    
    struct Main: Decodable {
        let temp: Double
        let humidity: Double
    }
    
    /// The city name
    let name: String?
    
    /// The datetime of the weather object. Only for forecast use.
    private let dt: TimeInterval?
    
    let weather: [Weather]
    let main: Main
    
    public var dateTime: Date? {
        if let dt = dt {
            return Date(timeIntervalSince1970: dt)
        }
        return nil
    }
    
    public var currentWeather: WeatherItem {
        WeatherItem(
            cityName: name,
            dateTime: dateTime,
            description: weather.first!.main,
            iconName: weather.first!.icon,
            temperature: main.temp,
            humidity: main.humidity
        )
    }
}

struct ForecastItem: Decodable {
    let list: [WeatherItemDecodable]
}
