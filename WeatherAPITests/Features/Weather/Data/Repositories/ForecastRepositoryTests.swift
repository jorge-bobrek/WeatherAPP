//
//  ForecastRepositoryTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

final class ForecastRepositoryTests: XCTestCase {
    var repository: ForecastRepository!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        repository = ForecastRepository(networkService: mockNetworkService)
    }

    override func tearDown() {
        repository = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testFetchForecastSuccess() async throws {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        let expectedForecast = WeatherModel(
            forecast: WeatherForecastModel(
                forecastday: [
                    WeatherForecastDayModel(
                        date: "2023-10-01",
                        day: ForecastDayModel(
                            avgtempC: 15.0,
                            condition: WeatherConditionModel(text: "Sunny", icon: "//example.com/sunny.png")
                        )
                    )
                ]
            )
        )
        mockNetworkService.fetchDataResult = .success(expectedForecast)

        // Act
        let result = try await repository.fetchForecast(for: location, days: 3)

        // Assert
        XCTAssertTrue(mockNetworkService.fetchDataCalled, "Fetch data should be called.")
        XCTAssertEqual(mockNetworkService.fetchDataEndpoint, "/forecast", "The endpoint should match.")
        XCTAssertEqual(mockNetworkService.fetchDataQueryParams, ["q": "London", "days": "3"], "The query params should match.")
        XCTAssertEqual(result, expectedForecast, "The returned forecast should match the expected forecast.")
    }

    func testFetchForecastNetworkError() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        let expectedError = NetworkError.invalidURL(urlString: "invalid-url")
        mockNetworkService.fetchDataResult = .failure(expectedError)

        // Act & Assert
        do {
            _ = try await repository.fetchForecast(for: location, days: 3)
            XCTFail("Expected an error to be thrown, but the repository succeeded.")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError, "The error should match the expected error.")
        }
    }

    func testFetchForecastInvalidStatusCode() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        let expectedError = NetworkError.httpError(statusCode: 404, message: "Not Found")
        mockNetworkService.fetchDataResult = .failure(expectedError)

        // Act & Assert
        do {
            _ = try await repository.fetchForecast(for: location, days: 3)
            XCTFail("Expected an error to be thrown, but the repository succeeded.")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError, "The error should match the expected error.")
        }
    }

    func testFetchForecastDecodingError() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        let expectedError = NetworkError.decodingFailed(type: String(describing: WeatherModel.self), innerError: DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid data")))
        mockNetworkService.fetchDataResult = .failure(expectedError)

        // Act & Assert
        do {
            _ = try await repository.fetchForecast(for: location, days: 3)
            XCTFail("Expected an error to be thrown, but the repository succeeded.")
        } catch {
            XCTAssertEqual(error as? NetworkError, expectedError, "The error should match the expected error.")
        }
    }
}
