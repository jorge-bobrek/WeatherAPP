//
//  MockLocationsRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

class MockLocationsRepository: AnyLocationsRepository {
    var locations: [LocationModel] = [
        LocationModel(id: 1, name: "London", country: "United Kingdom"),
        LocationModel(id: 2, name: "Cucuta", country: "Colombia")
    ]
    var shouldThrowError = false

    func fetchLocations(query: String) async throws -> [LocationModel] {
        if shouldThrowError {
            throw MockError.someError
        }
        return locations
    }
}
