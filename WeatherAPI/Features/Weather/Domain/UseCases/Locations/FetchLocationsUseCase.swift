//
//  FetchLocationsUseCase.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

class FetchLocationsUseCase {
    private let repository: AnyLocationsRepository

    init(repository: AnyLocationsRepository = LocationsRepository()) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [LocationModel] {
        return try await repository.fetchLocations(query: query)
    }
}
