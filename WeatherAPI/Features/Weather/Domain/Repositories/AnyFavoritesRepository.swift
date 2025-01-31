//
//  AnyForecastRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

protocol AnyForecastRepository {
    func fetchForecast(for location: LocationModel, days: Int) async throws -> WeatherModel
}
