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
        let condition = WeatherConditionModel(text: "Sunny", icon: "https://example.com/icon.png")
        let forecastDay = ForecastDayModel(avgTempC: 20.0, condition: condition)
        let forecastDayModel = WeatherForecastDayModel(date: "01-01-2025", day: forecastDay)
        let forecast = WeatherForecastModel(forecastday: [forecastDayModel])
        let expectedWeather = WeatherModel(forecast: forecast)
        
        mockFetchForecastUseCase.fetchWeatherResult = .success(expectedWeather)
        let location = LocationModel(id: 1, name: "London", country: "UK")

        // Act
        await viewModel.fetchForecast(for: location, days: 1)

        // Assert
        // Expect the weather data to be correctly set in the view model.
        XCTAssertEqual(viewModel.weather, expectedWeather, "Weather data should match the mock response.")
        // Expect no error to be present after a successful fetch.
        XCTAssertNil(viewModel.error, "Error should be nil after a successful fetch.")
        // Expect the loading state to be false after the fetch completes.
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetch completes.")
    }

    func testFetchForecastFailure() async {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockFetchForecastUseCase.fetchWeatherResult = .failure(expectedError)
        let location = LocationModel(id: 1, name: "London", country: "UK")

        // Act
        await viewModel.fetchForecast(for: location, days: 1)

        // Assert
        // Expect no weather data to be set after a failed fetch.
        XCTAssertNil(viewModel.weather, "Weather data should be nil after a failed fetch.")
        // Expect the error to be set in the view model.
        XCTAssertNotNil(viewModel.error, "Error should be set after a failed fetch.")
        // Expect the loading state to be false after the fetch completes.
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetch completes.")
    }

    func testFetchForecastWithEmptyForecastDay() async {
        // Arrange
        let forecast = WeatherForecastModel(forecastday: [])
        let expectedWeather = WeatherModel(forecast: forecast)
        
        mockFetchForecastUseCase.fetchWeatherResult = .success(expectedWeather)
        let location = LocationModel(id: 1, name: "London", country: "UK")

        // Act
        await viewModel.fetchForecast(for: location, days: 1)

        // Assert
        // Expect the weather data to be set even if the forecastday array is empty.
        XCTAssertEqual(viewModel.weather, expectedWeather, "Weather data should be set even with an empty forecastday array.")
        // Expect no error to be present after a successful fetch.
        XCTAssertNil(viewModel.error, "Error should be nil after a successful fetch with empty forecastday.")
        // Expect the loading state to be false after the fetch completes.
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
        // Expect no weather data to be set after a failed fetch due to invalid location.
        XCTAssertNil(viewModel.weather, "Weather data should be nil after a failed fetch due to invalid location.")
        // Expect the error to be set in the view model.
        XCTAssertNotNil(viewModel.error, "Error should be set after a failed fetch due to invalid location.")
        // Expect the loading state to be false after the fetch completes.
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetch completes.")
    }

    func testFetchForecastWithMultipleDays() async {
        // Arrange
        let condition1 = WeatherConditionModel(text: "Sunny", icon: "https://example.com/icon1.png")
        let condition2 = WeatherConditionModel(text: "Cloudy", icon: "https://example.com/icon2.png")
        let forecastDay1 = ForecastDayModel(avgTempC: 20.0, condition: condition1)
        let forecastDay2 = ForecastDayModel(avgTempC: 15.0, condition: condition2)
        let forecastDayModel1 = WeatherForecastDayModel(date: "01-01-2025", day: forecastDay1)
        let forecastDayModel2 = WeatherForecastDayModel(date: "02-01-2025", day: forecastDay2)
        let forecast = WeatherForecastModel(forecastday: [forecastDayModel1, forecastDayModel2])
        let expectedWeather = WeatherModel(forecast: forecast)
        
        mockFetchForecastUseCase.fetchWeatherResult = .success(expectedWeather)
        let location = LocationModel(id: 1, name: "London", country: "UK")

        // Act
        await viewModel.fetchForecast(for: location, days: 2)

        // Assert
        // Expect the weather data to include multiple days of forecast.
        XCTAssertEqual(viewModel.weather, expectedWeather, "Weather data should include multiple days of forecast.")
        // Expect no error to be present after a successful fetch.
        XCTAssertNil(viewModel.error, "Error should be nil after a successful fetch with multiple days.")
        // Expect the loading state to be false after the fetch completes.
        XCTAssertFalse(viewModel.isLoading, "Loading state should be false after fetch completes.")
    }

}
