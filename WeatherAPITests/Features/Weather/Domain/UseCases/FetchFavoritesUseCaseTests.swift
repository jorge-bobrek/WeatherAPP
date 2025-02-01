//
//  FetchFavoritesUseCaseTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

final class FetchFavoritesUseCaseTests: XCTestCase {
    var useCase: FetchFavoritesUseCase!
    var mockRepository: MockFavoritesRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockFavoritesRepository()
        useCase = FetchFavoritesUseCase(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Success Scenarios

    func testExecuteFetchFavoritesSuccess() async throws {
        // Arrange
        let expectedFavorites = [
            LocationModel(id: 1, name: "London", country: "UK"),
            LocationModel(id: 2, name: "Paris", country: "France")
        ]
        mockRepository.favorites = expectedFavorites

        // Act
        let result = try await useCase.execute()

        // Assert
        XCTAssertEqual(result, expectedFavorites, "The returned favorites should match the expected favorites.")
    }

    // MARK: - Edge Cases

    func testExecuteFetchFavoritesEmptyList() async throws {
        // Arrange
        mockRepository.favorites = [] // Simulate empty favorites list

        // Act
        let result = try await useCase.execute()

        // Assert
        XCTAssertTrue(result.isEmpty, "The returned favorites list should be empty.")
    }

    // MARK: - Failure Scenarios

    func testExecuteFetchFavoritesFailure() async {
        // Arrange
        mockRepository.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await useCase.execute()
            XCTFail("Expected an error to be thrown, but the use case succeeded.")
        } catch {
            XCTAssertTrue(error is MockError, "The error should be of type MockError.")
        }
    }
}
