//
//  FetchLocationsUseCaseTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

final class FetchLocationsUseCaseTests: XCTestCase {
    var useCase: FetchLocationsUseCase!
    var mockRepository: MockLocationsRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockLocationsRepository()
        useCase = FetchLocationsUseCase(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Success Scenarios

    func testExecuteFetchLocationsSuccess() async throws {
        // Arrange
        let expectedLocations = [
            LocationModel(id: 1, name: "Shinjuku", country: "Japan"),
            LocationModel(id: 2, name: "Cucuta", country: "Colombia")
        ]
        mockRepository.locations = expectedLocations

        // Act
        let result = try await useCase.execute(query: "Cucuta")

        // Assert
        XCTAssertEqual(result, expectedLocations, "The returned locations should match the expected locations.")
    }

    // MARK: - Edge Cases

    func testExecuteFetchLocationsEmptyQuery() async throws {
        // Arrange
        mockRepository.locations = [] // Simulate no results for empty query

        // Act
        let result = try await useCase.execute(query: "")

        // Assert
        XCTAssertTrue(result.isEmpty, "The returned locations list should be empty for an empty query.")
    }

    func testExecuteFetchLocationsNoResults() async throws {
        // Arrange
        mockRepository.locations = [] // Simulate no results for a query

        // Act
        let result = try await useCase.execute(query: "InvalidQuery")

        // Assert
        XCTAssertTrue(result.isEmpty, "The returned locations list should be empty for a query with no results.")
    }

    // MARK: - Failure Scenarios

    func testExecuteFetchLocationsFailure() async {
        // Arrange
        mockRepository.shouldThrowError = true

        // Act & Assert
        do {
            _ = try await useCase.execute(query: "London")
            XCTFail("Expected an error to be thrown, but the use case succeeded.")
        } catch {
            XCTAssertTrue(error is MockError, "The error should be of type MockError.")
        }
    }
}
