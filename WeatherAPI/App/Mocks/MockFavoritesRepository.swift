//
//  MockFavoritesRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

class MockFavoritesRepository: AnyFavoritesRepository {
    var favorites: [LocationModel] = [
        LocationModel(id: 0, name: "Shinjuku", country: "Japan")]
    var shouldThrowError = false

    func fetchFavorites() async throws -> [LocationModel] {
        if shouldThrowError {
            throw MockError.someError
        }
        return favorites
    }

    func addFavorite(_ location: LocationModel) async throws {
        if shouldThrowError {
            throw MockError.someError
        }
        favorites.append(location)
    }

    func removeFavorite(_ location: LocationModel) async throws {
        if shouldThrowError {
            throw MockError.someError
        }
        favorites.removeAll { $0.id == location.id }
    }
}

enum MockError: Error {
    case someError
}
