//
//  NetworkingError.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 1/02/25.
//

enum NetworkError: Error, Equatable {
    case invalidURL(urlString: String)
    case decodingFailed(type: String, innerError: DecodingError)
    case httpError(statusCode: Int, message: String)
    case noInternetConnection
    case timeout
    case networkError(code: Int, description: String)
    case invalidResponse
    case unknownError(description: String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid URL: \(urlString)"
        case .decodingFailed(let type, let innerError):
            return "Failed to decode \(type): \(innerError.localizedDescription)"
        case .httpError(let statusCode, let message):
            return "HTTP Error \(statusCode): \(message)"
        case .noInternetConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .networkError(let code, let description):
            return "Network Error (\(code)): \(description)"
        case .invalidResponse:
            return "Invalid server response"
        case .unknownError(let description):
            return "Unknown error: \(description)"
        }
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL(let lhsURL), .invalidURL(let rhsURL)):
            return lhsURL == rhsURL
        case (.decodingFailed(let lhsType, _), .decodingFailed(let rhsType, _)):
            return lhsType == rhsType
        case (.httpError(let lhsCode, _), .httpError(let rhsCode, _)):
            return lhsCode == rhsCode
        case (.noInternetConnection, .noInternetConnection),
            (.timeout, .timeout),
            (.invalidResponse, .invalidResponse):
            return true
        case (.networkError(let lhsCode, _), .networkError(let rhsCode, _)):
            return lhsCode == rhsCode
        case (.unknownError(let lhsDesc), .unknownError(let rhsDesc)):
            return lhsDesc == rhsDesc
        default:
            return false
        }
    }
}
