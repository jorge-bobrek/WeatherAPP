//
//  NetworkService.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

import Foundation

// MARK: - NetworkService
struct NetworkService: AnyNetworkService {
    static let shared = NetworkService()
    private let apiKey: String
    
    private init() {
        self.apiKey = APIKeyLoader.apiKey
    }
    
    func fetchData<T: Decodable>(endpoint: String, queryParams: [String: String]) async throws(NetworkError) -> T {
        do {
            // Build URL
            let baseURLString = "https://api.weatherapi.com/v1\(endpoint).json"
            var urlComponents = URLComponents(string: baseURLString)
            
            var queryItems = [URLQueryItem(name: "key", value: apiKey)]
            queryItems.append(contentsOf: queryParams.map { URLQueryItem(name: $0.key, value: $0.value) })
            urlComponents?.queryItems = queryItems
            
            guard let url = urlComponents?.url else {
                throw NetworkError.invalidURL(urlString: baseURLString)
            }
            
            // Perform Request
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Validate Status Code
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(
                    statusCode: httpResponse.statusCode,
                    message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode)
                )
            }
            
            // Decode Data
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(T.self, from: data)
            
        } catch let error as DecodingError {
            throw NetworkError.decodingFailed(
                type: String(describing: T.self),
                innerError: error
            )
        } catch let error as URLError {
            switch error.code {
            case .notConnectedToInternet:
                throw NetworkError.noInternetConnection
            case .timedOut:
                throw NetworkError.timeout
            default:
                throw NetworkError.networkError(code: error.code.rawValue, description: error.localizedDescription)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknownError(description: error.localizedDescription)
        }
    }
}

