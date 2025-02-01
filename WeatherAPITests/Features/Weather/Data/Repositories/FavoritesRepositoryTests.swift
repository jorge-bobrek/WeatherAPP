//
//  FavoritesRepositoryTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

final class FavoritesRepositoryTests: XCTestCase {
    var repository: FavoritesRepository!
    var mockPersistenceManager: MockPersistenceManager!

    override func setUp() {
        super.setUp()
        mockPersistenceManager = MockPersistenceManager()
        repository = FavoritesRepository(persistence: mockPersistenceManager)
    }

    override func tearDown() {
        repository = nil
        mockPersistenceManager = nil
        super.tearDown()
    }

    // MARK: - Success Scenarios

    func testFetchFavoritesSuccess() async throws {
        // Arrange
        let expectedFavorites = [
            LocationModel(id: 1, name: "London", country: "UK"),
            LocationModel(id: 2, name: "Paris", country: "France")
        ]
        mockPersistenceManager.favorites = expectedFavorites

        // Act
        let result = try await repository.fetchFavorites()

        // Assert
        XCTAssertEqual(result, expectedFavorites, "The returned favorites should match the expected favorites.")
    }

    func testAddFavoriteSuccess() async throws {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "UK")

        // Act
        try await repository.addFavorite(location)

        // Assert
        XCTAssertTrue(mockPersistenceManager.favorites.contains(location), "The location should be added to favorites.")
    }

    func testRemoveFavoriteSuccess() async throws {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "UK")
        mockPersistenceManager.favorites = [location]

        // Act
        try await repository.removeFavorite(location)

        // Assert
        XCTAssertFalse(mockPersistenceManager.favorites.contains(location), "The location should be removed from favorites.")
    }

    // MARK: - Failure Scenarios

    func testFetchFavoritesFailure() async {
        // Arrange
        mockPersistenceManager.shouldThrowError = true
        let expectedError = PersistenceError.fetchFailed(description: "TestError")

        // Act & Assert
        do {
            _ = try await repository.fetchFavorites()
            XCTFail("Expected an error to be thrown, but the repository succeeded.")
        } catch {
            XCTAssertEqual(error as? PersistenceError, expectedError, "The error should match the expected error.")
        }
    }

    func testAddFavoriteFailure() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "UK")
        mockPersistenceManager.shouldThrowError = true
        let expectedError = PersistenceError.saveFailed(description: "TestError")

        // Act & Assert
        do {
            try await repository.addFavorite(location)
            XCTFail("Expected an error to be thrown, but the repository succeeded.")
        } catch {
            XCTAssertEqual(error as? PersistenceError, expectedError, "The error should match the expected error.")
        }
    }

    func testRemoveFavoriteFailure() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "UK")
        mockPersistenceManager.favorites = [location]
        mockPersistenceManager.shouldThrowError = true
        let expectedError = PersistenceError.saveFailed(description: "TestError")

        // Act & Assert
        do {
            try await repository.removeFavorite(location)
            XCTFail("Expected an error to be thrown, but the repository succeeded.")
        } catch {
            XCTAssertEqual(error as? PersistenceError, expectedError, "The error should match the expected error.")
        }
    }
}
