//
//  PersistenceManagerTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 1/02/25.
//

import XCTest
@testable import WeatherAPI

final class PersistenceManagerTests: XCTestCase {
    var persistenceManager: PersistenceManager!

    override func setUp() {
        super.setUp()
        persistenceManager = PersistenceManager(inMemory: true)
    }

    override func tearDown() {
        persistenceManager = nil
        super.tearDown()
    }

    func testFetchFavoritesSuccess() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        do {
            try await persistenceManager.addFavorite(location)
        } catch {
            XCTFail("Failed to add favorite: \(error)")
        }

        // Act
        do {
            let favorites = try await persistenceManager.fetchFavorites()

            // Assert
            XCTAssertEqual(favorites.count, 1, "There should be one favorite.")
            XCTAssertEqual(favorites.first, location, "The favorite should match the added location.")
        } catch {
            XCTFail("Failed to fetch favorites: \(error)")
        }
    }

    func testFetchFavoritesEmpty() async {
        // Act
        do {
            let favorites = try await persistenceManager.fetchFavorites()

            // Assert
            XCTAssertTrue(favorites.isEmpty, "The favorites list should be empty.")
        } catch {
            XCTFail("Failed to fetch favorites: \(error)")
        }
    }

    func testAddFavoriteSuccess() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")

        // Act
        do {
            try await persistenceManager.addFavorite(location)
            let favorites = try await persistenceManager.fetchFavorites()

            // Assert
            XCTAssertEqual(favorites.count, 1, "The favorite should be added successfully.")
        } catch {
            XCTFail("Failed to add favorite: \(error)")
        }
    }

    func testAddFavoriteDuplicate() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")

        // Act
        do {
            try await persistenceManager.addFavorite(location)
            try await persistenceManager.addFavorite(location)
            let favorites = try await persistenceManager.fetchFavorites()

            // Assert
            XCTAssertEqual(favorites.count, 1, "Duplicate favorites should not be added.")
        } catch let error as PersistenceError {
            XCTAssertEqual(error, PersistenceError.saveFailed(description: "Favorite already exists"), "Trying to add duplicates should throw save error.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRemoveFavoriteSuccess() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        do {
            try await persistenceManager.addFavorite(location)
        } catch {
            XCTFail("Failed to add favorite: \(error)")
        }

        // Act
        do {
            try await persistenceManager.removeFavorite(location)
            let favorites = try await persistenceManager.fetchFavorites()

            // Assert
            XCTAssertTrue(favorites.isEmpty, "The favorite should be removed successfully.")
        } catch {
            XCTFail("Failed to remove favorite: \(error)")
        }
    }

    func testRemoveFavoriteNonExistent() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")

        // Act
        do {
            try await persistenceManager.removeFavorite(location)
            XCTFail("Removing a non-existent favorite should throw an error.")
        } catch let error as PersistenceError {
            // Assert
            XCTAssertEqual(error, PersistenceError.itemNotFound, "The error should be itemNotFound.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
