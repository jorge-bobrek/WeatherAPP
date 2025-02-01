//
//  MockPersistenceManager.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import CoreData
import Foundation
@testable import WeatherAPI

final class MockPersistenceManager: AnyPersistenceManager {    
    var favorites: [LocationModel] = []
    var shouldThrowError = false

    func fetchFavorites() throws -> [LocationModel] {
        if shouldThrowError {
            throw PersistenceError.fetchFailed(description: "TestError")
        }
        return favorites
    }

    func addFavorite(_ location: LocationModel) throws {
        if shouldThrowError {
            throw PersistenceError.saveFailed(description: "TestError")
        }
        favorites.append(location)
    }

    func removeFavorite(_ location: LocationModel) throws {
        if shouldThrowError {
            throw PersistenceError.saveFailed(description: "TestError")
        }
        favorites.removeAll { $0.id == location.id }
    }
}
