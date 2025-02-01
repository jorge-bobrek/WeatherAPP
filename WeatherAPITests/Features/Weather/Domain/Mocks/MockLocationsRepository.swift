//
//  MockLocationsRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

@testable import WeatherAPI

class MockLocationsRepository: AnyLocationsRepository {
    var locations: [LocationModel] = []
    var shouldThrowError = false

    func fetchLocations(query: String) async throws -> [LocationModel] {
        if shouldThrowError {
            throw MockError.someError
        }
        return locations
    }
}
