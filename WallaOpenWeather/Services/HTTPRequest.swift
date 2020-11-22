//
//  NetworkClient.swift
//  WallaOpenWeather
//
//  Created by Eilon Krauthammer on 19/11/2020.
//

import Foundation

struct HTTPRequest {
    
    typealias QueryParams = Dictionary<String, Any>
    
    private var url: URL?
    
    enum NetworkingError: Error {
        case badURL
        case badRequest
        case unknown
    }
    
    /// Basic initialization
    public init(urlString: String, queryParams: QueryParams? = .none) {
        if let params = queryParams {
            var newStr = urlString
            newStr.append("?")
            for (k, v) in params {
                newStr.append("\(k)=\(v)")
                newStr.append("&")
            }
            newStr.removeLast()
            
            self.url = URL(string: newStr)
        } else {
            self.url = URL(string: urlString)
        }
    }
    
    public func get<T: Decodable>(_ type: T.Type, callback: @escaping (Result<T, Error>) -> Void) {
        guard let url = self.url else {
            callback(.failure(NetworkingError.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    callback(.failure(error))
                }
                return
            }
            
            guard
                let _httpResponse = response,
                let httpResponse = _httpResponse as? HTTPURLResponse,
                let data = data
            else { print("Unknown error occured."); return }
            
            if Environment.isDebug {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            if httpResponse.statusCode != 200 {
                DispatchQueue.main.async {
                    callback(.failure(NetworkingError.badRequest))
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let responseObject = try JSONDecoder().decode(type, from: data)
                    callback(.success(responseObject))
                } catch let e {
                    callback(.failure(e))
                }
            }
        }.resume()
    }
}
