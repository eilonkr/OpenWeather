//
//  NetworkManager.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import Foundation

struct NetworkManager {
    
    // MARK: - Endpoints
    
    enum Endpoints: String {
        static private let baseURL = "https://api.openweathermap.org/data/2.5/"

        case weather
        case forecast
        
        var path: String { Self.baseURL + rawValue }
    }
    
    // MARK: - Common
    
    typealias CurrentWeatherResultHandler = (Result<WeatherItem, Error>) -> Void
    typealias WeatherItemsResult = (Result<[WeatherItem], Error>) -> Void
    
    private static func commonParams(_ cityName: String) -> [String: Any] {
        return [
            "q": cityName.replacingOccurrences(of: " ", with: "%20"),
            "units": "metric",
            "appid": Environment.Secrets.WEATHER_API_KEY
        ]
    }
}


// MARK: - Main Screen Requests

extension NetworkManager {
    private static func getCurrentWeatherData(forCity cityName: String, handler: @escaping CurrentWeatherResultHandler) {
        let urlString = Endpoints.weather.path
        let request = HTTPRequest(urlString: urlString, queryParams: commonParams(cityName))
        request.get(WeatherItemDecodable.self) { result in
            switch result {
                case .success(let weatherData):
                    handler(.success(weatherData.currentWeather))
                case .failure(let error):
                    handler(.failure(error))
            }
        }
    }
    
    static func getCurrentWeatherData(forCities cityNames: [String], handler: @escaping WeatherItemsResult) {
        var weatherItems = [WeatherItem]()
        var error: Error?
        
        let disptachGroup = DispatchGroup()
        for city in cityNames {
            disptachGroup.enter()
            getCurrentWeatherData(forCity: city) { result in
                defer { disptachGroup.leave() }
                switch result {
                    case .success(let weatherItem):
                        weatherItems.append(weatherItem)
                    case .failure(let e):
                        print("Failed to read weather for \(city): \n \(e)")
                        error = e
                }
            }
        }
        
        disptachGroup.notify(queue: .main) {
            if error != nil || weatherItems.count > 0 {
                let orderedItems = weatherItems.sorted { $0.cityName ?? "" > $1.cityName ?? "" }
                handler(.success(orderedItems))
            } else if let error = error {
                handler(.failure(error))
            }
        }
    }
}

// MARK: - City Screen Requests

extension NetworkManager {
    static func getFiveDayForecast(forCity cityName: String, handler: @escaping WeatherItemsResult) {
        let urlString = Endpoints.forecast.path
        let request = HTTPRequest(urlString: urlString, queryParams: commonParams(cityName))
        request.get(ForecastItem.self) { result in
            switch result {
                case .success(let forecastData):
                    let weatherItems = forecastData.list
                    var filteredItems = [WeatherItemDecodable]()
                    // Selectively query for 5 days
                    for i in 0 ..< weatherItems.count {
                        if i % 8 == 0 {
                            if let item = weatherItems[safe: i] {
                                filteredItems.append(item)
                            }
                        }
                    }
                    handler(.success(filteredItems.map(\.currentWeather)))
                case .failure(let error):
                    handler(.failure(error))
            }
        }
    }
}
