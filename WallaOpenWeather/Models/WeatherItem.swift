//
//  WeatherData.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import Foundation

struct WeatherItem: Identifiable, Codable {
    internal var id = UUID().uuidString
        
    let cityName: String?
    let dateTime: Date?
    let description: String
    let iconName: String
    
    private let temperature: Double
    private let humidity: Double
    
    init(cityName: String?, dateTime: Date? = nil, description: String, iconName: String, temperature: Double, humidity: Double) {
        self.cityName = cityName
        self.dateTime = dateTime
        self.description = description
        self.iconName = iconName
        self.temperature = temperature
        self.humidity = humidity
    }
    
    // MARK: - Weather Helpers
    
    public var formattedTemperature: String {
        String(format: "%0.1f", temperature) + "°"
    }
    
    public var formattedShortTemperature: String {
        String(format: "%0.0f", temperature) + "°"
    }
    
    public var formattedHumidity: String {
        String(format: "h: %0.0f", humidity) + "%"
    }
    
    // MARK: - Date Helpers
    
    public var dayStringFromDate: String? {
        if let dateTime = dateTime {
            guard let weekDay = Calendar.current.dateComponents([.weekday], from: dateTime).weekday else { return nil }
            return Calendar.current.weekdayNameFrom(weekdayNumber: weekDay)
        }
        return nil
    }
    
}
