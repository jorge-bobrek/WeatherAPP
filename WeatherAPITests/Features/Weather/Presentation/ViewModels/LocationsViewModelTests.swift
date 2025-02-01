//
//  LocationsViewModelTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

@MainActor
final class LocationsViewModelTests: XCTestCase {
    var viewModel: LocationsViewModel!
    var mockFetchLocationsUseCase: MockFetchLocationsUseCase!
    var mockLocationsRepository: MockLocationsRepository!

    override func setUp() {
        super.setUp()
        mockLocationsRepository = MockLocationsRepository()
        mockFetchLocationsUseCase = MockFetchLocationsUseCase(repository: mockLocationsRepository)
        viewModel = LocationsViewModel(fetchLocationsUseCase: mockFetchLocationsUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockLocationsRepository = nil
        mockFetchLocationsUseCase = nil
        super.tearDown()
    }

    func testFetchLocationsSuccess() async {
        // Arrange
        let expectedLocations = [
            LocationModel(id: 1, name: "London", country: "United Kingdom"),
            LocationModel(id: 2, name: "Cucuta", country: "Colombia")
        ]
        mockFetchLocationsUseCase.fetchLocationsResult = .success(expectedLocations)

        // Act
        await viewModel.fetchLocations(query: "London")

        // Assert
        XCTAssertEqual(viewModel.locations, expectedLocations, "The locations should match the expected locations.")
        XCTAssertNil(viewModel.error, "The error should be nil.")
        XCTAssertFalse(viewModel.isLoading, "The loading state should be false.")
    }

    func testFetchLocationsFailure() async {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockFetchLocationsUseCase.fetchLocationsResult = .failure(expectedError)

        // Act
        await viewModel.fetchLocations(query: "InvalidQuery")

        // Assert
        XCTAssertTrue(viewModel.locations.isEmpty, "The locations should be empty.")
        XCTAssertEqual(viewModel.error as? NSError, expectedError, "The error should match the expected error.")
        XCTAssertFalse(viewModel.isLoading, "The loading state should be false.")
    }

    func testFetchLocationsWithEmptyQuery() async {
        // Arrange
        let expectedLocations = [LocationModel]()
        mockFetchLocationsUseCase.fetchLocationsResult = .success(expectedLocations)

        // Act
        await viewModel.fetchLocations(query: "")

        // Assert
        XCTAssertTrue(viewModel.locations.isEmpty, "The locations should be empty for an empty query.")
        XCTAssertNil(viewModel.error, "The error should be nil.")
        XCTAssertFalse(viewModel.isLoading, "The loading state should be false.")
    }
}
