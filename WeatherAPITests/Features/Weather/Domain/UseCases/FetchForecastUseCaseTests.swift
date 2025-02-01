//
//  FetchForecastUseCaseTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

final class FetchForecastUseCaseTests: XCTestCase {
    var useCase: FetchForecastUseCase!
    var mockRepository: MockForecastRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockForecastRepository()
        useCase = FetchForecastUseCase(repository: mockRepository)
    }

    override func tearDown() {
        useCase = nil
        mockRepository = nil
        super.tearDown()
    }

    // MARK: - Success Scenario

    func testExecuteFetchForecastSuccess() async throws {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "UK")
        let expectedForecast = WeatherModel(
            forecast: WeatherForecastModel(
                forecastday: [
                    WeatherForecastDayModel(
                        date: "2023-10-01",
                        day: ForecastDayModel(
                            avgTempC: 15.0,
                            condition: WeatherConditionModel(text: "Sunny", icon: "sunny.png")
                        )
                    )
                ]
            )
        )
        mockRepository.fetchForecastResult = .success(expectedForecast)

        // Act
        let result = try await useCase.execute(for: location, days: 3)

        // Assert
        XCTAssertTrue(mockRepository.fetchForecastCalled, "Fetch forecast should be called.")
        XCTAssertEqual(mockRepository.fetchForecastLocation, location, "The location should match.")
        XCTAssertEqual(mockRepository.fetchForecastDays, 3, "The days parameter should match.")
        XCTAssertEqual(result, expectedForecast, "The returned forecast should match the expected forecast.")
    }

    // MARK: - Edge Cases

    func testExecuteFetchForecastEmptyForecast() async throws {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "UK")
        let expectedForecast = WeatherModel(forecast: WeatherForecastModel(forecastday: []))
        mockRepository.fetchForecastResult = .success(expectedForecast)

        // Act
        let result = try await useCase.execute(for: location, days: 3)

        // Assert
        XCTAssertTrue(result.forecast.forecastday.isEmpty, "The forecast should be empty.")
    }

    // MARK: - Failure Scenarios

    func testExecuteFetchForecastFailure() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "UK")
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockRepository.fetchForecastResult = .failure(expectedError)

        // Act & Assert
        do {
            _ = try await useCase.execute(for: location, days: 3)
            XCTFail("Expected an error to be thrown, but the use case succeeded.")
        } catch {
            XCTAssertEqual(error as NSError, expectedError, "The error should match the expected error.")
        }
    }
}
