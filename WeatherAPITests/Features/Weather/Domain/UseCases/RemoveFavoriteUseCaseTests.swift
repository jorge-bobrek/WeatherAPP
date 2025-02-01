//
//  RemoveFavoriteUseCaseTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

final class RemoveFavoriteUseCaseTests: XCTestCase {
    var useCase: RemoveFavoriteUseCase!
    var mockRepository: MockFavoritesRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockFavoritesRepository()
        useCase = RemoveFavoriteUseCase(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    func testExecuteRemoveFavoriteSuccess() async throws {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        mockRepository.favorites = [location]

        // Act
        try await useCase.execute(location)

        // Assert
        XCTAssertFalse(mockRepository.favorites.contains(location), "The location should be removed from favorites.")
    }

    // MARK: - Edge Cases

    func testExecuteRemoveNonExistentFavorite() async throws {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        mockRepository.favorites = []

        // Act
        try await useCase.execute(location)

        // Assert
        XCTAssertTrue(mockRepository.favorites.isEmpty, "The favorites list should remain empty.")
    }

    func testExecuteRemoveFavoriteFailure() async {
        // Arrange
        mockRepository.shouldThrowError = true

        // Act & Assert
        do {
            try await useCase.execute(LocationModel(id: 1, name: "London", country: "United Kingdom"))
            XCTFail("Expected an error to be thrown, but the use case succeeded.")
        } catch {
            XCTAssertTrue(error is MockError, "The error should be of type MockError.")
        }
    }
}
