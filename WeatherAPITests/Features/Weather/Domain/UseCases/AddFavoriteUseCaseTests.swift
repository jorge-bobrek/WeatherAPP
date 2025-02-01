//
//  AddFavoriteUseCaseTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

final class AddFavoriteUseCaseTests: XCTestCase {
    var useCase: AddFavoriteUseCase!
    var mockRepository: MockFavoritesRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockFavoritesRepository()
        useCase = AddFavoriteUseCase(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Success Scenarios

    func testExecuteAddFavoriteSuccess() async throws {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "UK")

        // Act
        try await useCase.execute(location)

        // Assert
        XCTAssertTrue(mockRepository.addedFavorites.contains(location), "The location should be added to favorites.")
    }

    // MARK: - Edge Cases

    func testExecuteAddDuplicateFavorite() async throws {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "UK")
        mockRepository.favorites = [location] // Simulate existing favorite

        // Act
        try await useCase.execute(location)

        // Assert
        XCTAssertEqual(mockRepository.addedFavorites.count, 1, "Duplicate favorite should not be added.")
    }

    // MARK: - Failure Scenarios

    func testExecuteAddFavoriteFailure() async {
        // Arrange
        mockRepository.shouldThrowError = true

        // Act & Assert
        do {
            try await useCase.execute(LocationModel(id: 1, name: "London", country: "UK"))
            XCTFail("Expected an error to be thrown, but the use case succeeded.")
        } catch {
            XCTAssertTrue(error is MockError, "The error should be of type MockError.")
        }
    }
}
