//
//  MockFetchForecastUseCase.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import Foundation
@testable import WeatherAPI

class MockFetchForecastUseCase: FetchForecastUseCase {
    var fetchWeatherResult: Result<WeatherModel, Error> = .success(
        WeatherModel(forecast: WeatherForecastModel(forecastday: [])))

    override func execute(for location: LocationModel, days: Int) async throws -> WeatherModel {
        switch fetchWeatherResult {
        case .success(let weather):
            return weather
        case .failure(let error):
            throw error
        }
    }
}
