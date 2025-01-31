//
//  NetworkService.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

import Foundation

struct NetworkService: AnyNetworkService {
    static let shared = NetworkService()
    private let apiKey: String
    
    private init() {
        self.apiKey = APIKeyLoader.apiKey
    }
    
    func fetchData<T: Decodable>(endpoint: String, queryParams: [String: String]) async throws(NetworkingError) -> T {
        do {
            var urlComponents = URLComponents(string: "https://api.weatherapi.com/v1\(endpoint).json")!
            
            var queryItems = [URLQueryItem(name: "key", value: self.apiKey)]
            for (key, value) in queryParams {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItems
            
            guard let url = urlComponents.url else {
                throw NetworkingError.invalidURL
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkingError.invalidStatusCode(statusCode: -1)
            }
            guard (200...299).contains(statusCode) else {
                throw NetworkingError.invalidStatusCode(statusCode: statusCode)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw .decodingFailed(innerError: error)
        } catch let error as URLError {
            throw .requestFailed(innerError: error)
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw .otherError(innerError: error)
        }
    }
}

enum NetworkingError: Error {
    case invalidURL
    case decodingFailed(innerError: DecodingError)
    case invalidStatusCode(statusCode: Int)
    case requestFailed(innerError: URLError)
    case otherError(innerError: Error)
}
