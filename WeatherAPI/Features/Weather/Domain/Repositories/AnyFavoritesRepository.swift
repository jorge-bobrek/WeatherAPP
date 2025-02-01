//
//  AnyFavoritesRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

protocol AnyFavoritesRepository {
    func fetchFavorites() async throws -> [LocationModel]
    func addFavorite(_ location: LocationModel) async throws
    func removeFavorite(_ location: LocationModel) async throws
}
