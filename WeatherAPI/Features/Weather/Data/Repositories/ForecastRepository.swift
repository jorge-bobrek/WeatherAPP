//
//  ForecastRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

class ForecastRepository: AnyForecastRepository {
    private let networkService: AnyNetworkService
    
    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }

    func fetchForecast(for location: LocationModel, days: Int) async throws -> WeatherModel {
        let forecastQueryParams = ["q": location.name, "days": String(days)]
        return try await networkService.fetchData(endpoint: "/forecast", queryParams: forecastQueryParams)
    }
}
