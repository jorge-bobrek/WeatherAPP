//
//  FetchForecastUseCase.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

class FetchForecastUseCase {
    private let repository: AnyForecastRepository

    init(repository: AnyForecastRepository = ForecastRepository()) {
        self.repository = repository
    }

    func execute(for location: LocationModel, days: Int) async throws -> WeatherModel {
        return try await repository.fetchForecast(for: location, days: days)
    }
}
