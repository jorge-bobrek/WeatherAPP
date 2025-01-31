//
//  AnyNetworkService.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//


protocol AnyNetworkService {
    func fetchData<T: Decodable>(endpoint: String, queryParams: [String: String]) async throws -> T
}
