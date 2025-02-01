//
//  MockFetchLocationsUseCase.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//


import Foundation
@testable import WeatherAPI

final class MockFetchLocationsUseCase: FetchLocationsUseCase {
    var fetchLocationsResult: Result<[LocationModel], Error> = .success([])
    
    override func execute(query: String) async throws -> [LocationModel] {
        switch fetchLocationsResult {
        case .success(let locations):
            return locations
        case .failure(let error):
            throw error
        }
    }
}
