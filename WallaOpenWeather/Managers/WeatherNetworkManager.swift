//
//  NetworkManager.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import Foundation
import Moya

final class WeatherNetworkManager {
    /// A notorious Singleton.
    static let shared = WeatherNetworkManager()
    
    private let provider = MoyaProvider<WeatherService>()
    
    /// hey don't touch this!
    private init() { }
    
    typealias WeatherItemsResult = (Result<[WeatherItem], Error>) -> Void
}

// MARK: - Current Weather requests

extension WeatherNetworkManager {
    func getCurrentWeatherData(forCities cityNames: [String], handler: @escaping WeatherItemsResult) {
        var weatherItems = [WeatherItem?]()
        var error: Error?
        
        let disptachGroup = DispatchGroup()
        for city in cityNames {
            disptachGroup.enter()
            provider.request(.current(cityName: city)) { result in
                defer { disptachGroup.leave() }
                switch result {
                    case .success(let response):
                        do {
                            let weatherItem = try response.decode(WeatherItemDecodable.self).currentWeather
                            weatherItems.append(weatherItem)
                        } catch let e {
                            error = e
                        }
                    case .failure(let e):
                        error = e
                }
            }
        }
        
        disptachGroup.notify(queue: .main) {
            if error != nil || weatherItems.count > 0 {
                let orderedItems = weatherItems.compactMap {$0}
                    .sorted { $0.cityName ?? "" > $1.cityName ?? "" }
                handler(.success(orderedItems))
            } else if let error = error {
                handler(.failure(error))
            }
        }
    }
}

// MARK: - Forecast requests

extension WeatherNetworkManager {
    func getFiveDayForecast(forCity cityName: String, handler: @escaping WeatherItemsResult) {
        provider.request(.forecast(cityName: cityName)) { result in
            switch result {
                case .success(let response):
                    do {
                        let items = try response.decode(ForecastItem.self).list
                        let filteredItems = Self.queryFiveDays(from: items)
                        handler(.success(filteredItems.map(\.currentWeather)))
                    } catch {
                        handler(.failure(error))
                    }
                case .failure(let error):
                    handler(.failure(error))
            }
        }
    }
    
    static private func queryFiveDays(from items: [WeatherItemDecodable]) -> [WeatherItemDecodable] {
        var filteredItems = [WeatherItemDecodable]()
        // Selectively query for 5 days
        for i in 0 ..< items.count {
            if i % 8 == 0 {
                if let item = items[safe: i] {
                    filteredItems.append(item)
                }
            }
        }
        
        return filteredItems
    }
}

// MARK: - `Moya.Response` extension to enable decoding `Decodable` types.

extension Moya.Response {
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return try JSONDecoder().decode(type, from: data)
    }
}

