//
//  AnyFavoritesRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

protocol AnyFavoritesRepository {
    func fetchFavorites() throws -> [LocationModel]
    func addFavorite(_ location: LocationModel) throws
    func removeFavorite(_ location: LocationModel) throws
}
