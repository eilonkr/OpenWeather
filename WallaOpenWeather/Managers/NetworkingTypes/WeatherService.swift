//
//  WeatherService.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 25/11/2020.
//

import Foundation
import Moya

enum WeatherService {
    case current(cityName: String)
    case forecast(cityName: String)
    
    var urlPath: String {
        switch self {
            case .current(_):
                return "weather"
            case .forecast(_):
                return "forecast"
        }
    }
    
    var commonParams: [String: Any] {
        var cityName: String
        
        switch self {
            case .current(let city):
                cityName = city
            case .forecast(let city):
                cityName = city
        }
        
        return [
            "q": cityName,
            "units": "metric",
            "appid": Environment.Secrets.WEATHER_API_KEY
        ]
    }
}

extension WeatherService: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/") else {
            fatalError("Invalid API URL.")
        }
        return url
    }
    
    var path: String { urlPath }
    
    var headers: [String : String]? { nil }
    
    var method: Moya.Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task {
        .requestParameters(parameters: commonParams, encoding: URLEncoding.queryString)
    }
}
