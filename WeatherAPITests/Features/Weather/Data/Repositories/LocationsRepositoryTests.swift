//
//  LocationsRepositoryTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

final class LocationsRepositoryTests: XCTestCase {
    var repository: LocationsRepository!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        repository = LocationsRepository(networkService: mockNetworkService)
    }

    override func tearDown() {
        repository = nil
        mockNetworkService = nil
        super.tearDown()
    }

    // MARK: - Success Scenario

    func testFetchLocationsSuccess() async throws {
        // Arrange
        let expectedLocations = [
            LocationModel(id: 1, name: "London", country: "UK"),
            LocationModel(id: 2, name: "Paris", country: "France")
        ]
        mockNetworkService.fetchDataResult = .success(expectedLocations)

        // Act
        let result = try await repository.fetchLocations(query: "London")

        // Assert
        XCTAssertTrue(mockNetworkService.fetchDataCalled, "Fetch data should be called.")
        XCTAssertEqual(mockNetworkService.fetchDataEndpoint, "/search", "The endpoint should match.")
        XCTAssertEqual(mockNetworkService.fetchDataQueryParams, ["q": "London"], "The query params should match.")
        XCTAssertEqual(result, expectedLocations, "The returned locations should match the expected locations.")
    }

    // MARK: - Failure Scenarios

    func testFetchLocationsNetworkError() async {
        // Arrange
        let expectedError = NetworkError.invalidURL(urlString: "invalid-url")
        mockNetworkService.fetchDataResult = .failure(expectedError)

        // Act & Assert
        do {
            _ = try await repository.fetchLocations(query: "London")
            XCTFail("Expected an error to be thrown, but the repository succeeded.")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError, "The error should match the expected error.")
        }
    }

    func testFetchLocationsInvalidStatusCode() async {
        // Arrange
        let expectedError = NetworkError.httpError(statusCode: 404, message: "Not Found")
        mockNetworkService.fetchDataResult = .failure(expectedError)

        // Act & Assert
        do {
            _ = try await repository.fetchLocations(query: "London")
            XCTFail("Expected an error to be thrown, but the repository succeeded.")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError, "The error should match the expected error.")
        }
    }

    func testFetchLocationsDecodingError() async {
        // Arrange
        let expectedError = NetworkError.decodingFailed(type: String(describing: LocationModel.self), innerError: DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid data")))
        mockNetworkService.fetchDataResult = .failure(expectedError)

        // Act & Assert
        do {
            _ = try await repository.fetchLocations(query: "London")
            XCTFail("Expected an error to be thrown, but the repository succeeded.")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError, "The error should match the expected error.")
        }
    }
}
