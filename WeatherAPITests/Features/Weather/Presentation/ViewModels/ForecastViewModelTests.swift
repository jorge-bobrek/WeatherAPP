//
//  ForecastViewModelTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

@MainActor
class ForecastViewModelTests: XCTestCase {

    var viewModel: ForecastViewModel!
    var mockFetchForecastUseCase: MockFetchForecastUseCase!
    var mockForecastRepository: MockForecastRepository!

    override func setUp() {
        super.setUp()
        mockForecastRepository = MockForecastRepository()
        mockFetchForecastUseCase = MockFetchForecastUseCase(repository: mockForecastRepository)
        viewModel = ForecastViewModel(fetchForecastUseCase: mockFetchForecastUseCase)
    }

    override func tearDown() {
        viewModel = nil
        mockForecastRepository = nil
        mockFetchForecastUseCase = nil
        super.tearDown()
    }

    func testFetchForecastSuccess() async {
        // Arrange
        let condition = WeatherConditionModel(text: "Sunny", icon: "//example.com/sunny.png")
        let forecastDay = ForecastDayModel(avgtempC: 20.0, condition: condition)
        let forecastDayModel = WeatherForecastDayModel(date: "01-01-2025", day: forecastDay)
        let forecast = WeatherForecastModel(forecastday: [forecastDayModel])
        let expectedWeather = WeatherModel(forecast: forecast)
        
        mockFetchForecastUseCase.fetchWeatherResult = .success(expectedWeather)
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")

        // Act
        await viewModel.fetchForecast(for: location, days: 1)

        // Assert
        XCTAssertEqual(viewModel.weather, expectedWeather, "Weather data should match the mock response.")
        XCTAssertNil(viewModel.error, "Error should be nil after a successful fetch.")
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetch completes.")
    }

    func testFetchForecastFailure() async {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockFetchForecastUseCase.fetchWeatherResult = .failure(expectedError)
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")

        // Act
        await viewModel.fetchForecast(for: location, days: 1)

        // Assert
        XCTAssertNil(viewModel.weather, "Weather data should be nil after a failed fetch.")
        XCTAssertNotNil(viewModel.error, "Error should be set after a failed fetch.")
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetch completes.")
    }

    func testFetchForecastWithEmptyForecastDay() async {
        // Arrange
        let forecast = WeatherForecastModel(forecastday: [])
        let expectedWeather = WeatherModel(forecast: forecast)
        
        mockFetchForecastUseCase.fetchWeatherResult = .success(expectedWeather)
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")

        // Act
        await viewModel.fetchForecast(for: location, days: 1)

        // Assert
        XCTAssertEqual(viewModel.weather, expectedWeather, "Weather data should be set even with an empty forecastday array.")
        XCTAssertNil(viewModel.error, "Error should be nil after a successful fetch with empty forecastday.")
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetch completes.")
    }

    func testFetchForecastWithInvalidLocation() async {
        // Arrange
        let expectedError = NSError(domain: "LocationError", code: 404, userInfo: nil)
        mockFetchForecastUseCase.fetchWeatherResult = .failure(expectedError)
        let invalidLocation = LocationModel(id: 999, name: "Invalid", country: "Invalid")

        // Act
        await viewModel.fetchForecast(for: invalidLocation, days: 1)

        // Assert
        XCTAssertNil(viewModel.weather, "Weather data should be nil after a failed fetch due to invalid location.")
        XCTAssertNotNil(viewModel.error, "Error should be set after a failed fetch due to invalid location.")
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetch completes.")
    }

    func testFetchForecastWithMultipleDays() async {
        // Arrange
        let expectedWeather = WeatherModel(
            forecast: WeatherForecastModel(
                forecastday: [
                    WeatherForecastDayModel(
                        date: "01-01-2025",
                        day: ForecastDayModel(
                            avgtempC: 20.0,
                            condition: WeatherConditionModel(
                                text: "Sunny",
                                icon: "//example.com/sunny.png"
                            )
                        )
                    ), WeatherForecastDayModel(
                        date: "02-01-2025",
                        day: ForecastDayModel(
                            avgtempC: 15.0,
                            condition: WeatherConditionModel(
                                text: "Cloudy",
                                icon: "//example.com/cloudy.png"
                            )
                        )
                    )
                ]
            )
        )
        mockFetchForecastUseCase.fetchWeatherResult = .success(expectedWeather)
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")

        // Act
        await viewModel.fetchForecast(for: location, days: 2)

        // Assert
        XCTAssertEqual(viewModel.weather, expectedWeather, "Weather data should include multiple days of forecast.")
        XCTAssertNil(viewModel.error, "Error should be nil after a successful fetch with multiple days.")
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetch completes.")
    }

}
