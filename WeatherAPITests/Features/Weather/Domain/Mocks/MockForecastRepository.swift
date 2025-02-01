//
//  MockForecastRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

@testable import WeatherAPI

final class MockForecastRepository: AnyForecastRepository {
    var fetchForecastResult: Result<WeatherModel, Error> = .success(
        WeatherModel(forecast: WeatherForecastModel(forecastday: []))
    )
    var fetchForecastCalled = false
    var fetchForecastLocation: LocationModel?
    var fetchForecastDays: Int?

    func fetchForecast(for location: LocationModel, days: Int) async throws -> WeatherModel {
        fetchForecastCalled = true
        fetchForecastLocation = location
        fetchForecastDays = days

        switch fetchForecastResult {
        case .success(let weatherModel):
            return weatherModel
        case .failure(let error):
            throw error
        }
    }
}
