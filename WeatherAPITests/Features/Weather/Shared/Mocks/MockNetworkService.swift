//
//  MockNetworkService.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import Foundation
@testable import WeatherAPI

final class MockNetworkService: AnyNetworkService {
    var fetchDataResult: Result<Any, NetworkError> = .success([:])
    var fetchDataCalled = false
    var fetchDataEndpoint: String?
    var fetchDataQueryParams: [String: String]?

    func fetchData<T: Decodable>(endpoint: String, queryParams: [String: String]) async throws -> T {
        fetchDataCalled = true
        fetchDataEndpoint = endpoint
        fetchDataQueryParams = queryParams

        switch fetchDataResult {
        case .success(let data):
            if let typedData = data as? T {
                return typedData
            } else {
                throw NetworkError.decodingFailed(type: String(describing: T.self), innerError: DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Failed to cast data to expected type")))
            }
        case .failure(let error):
            throw error
        }
    }
}
