//
//  FavoritesRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

import CoreData

class FavoritesRepository: AnyFavoritesRepository {
    private let persistence: AnyPersistenceManager

    init(persistence: AnyPersistenceManager) {
        self.persistence = persistence
    }
    
    func fetchFavorites() async throws -> [LocationModel] {
        try await persistence.fetchFavorites()
    }
    
    func addFavorite(_ location: LocationModel) async throws {
        try await persistence.addFavorite(location)
    }
    
    func removeFavorite(_ location: LocationModel) async throws {
        try await persistence.removeFavorite(location)
    }
}
