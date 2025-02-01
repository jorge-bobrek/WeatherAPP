//
//  ForecastViewModel.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

import SwiftUI

@MainActor
class ForecastViewModel: ObservableObject {
    @Published var weather: WeatherModel?
    @Published var error: Error?
    @Published var isLoading: Bool = false

    private let fetchForecastUseCase: FetchForecastUseCase

    init(fetchForecastUseCase: FetchForecastUseCase) {
        self.fetchForecastUseCase = fetchForecastUseCase
    }

    func fetchForecast(for location: LocationModel, days: Int) async {
        isLoading = true
        error = nil
        do {
            let fetchedWeather = try await fetchForecastUseCase.execute(for: location, days: days)
            weather = fetchedWeather
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
