//
//  AnyLocationsRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

protocol AnyLocationsRepository {
    func fetchLocations(query: String) async throws -> [LocationModel]
}
