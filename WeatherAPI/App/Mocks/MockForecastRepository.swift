//
//  MockForecastRepository.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

final class MockForecastRepository: AnyForecastRepository {
    var fetchForecastResult: Result<WeatherModel, Error> = .success(
        WeatherModel(
            forecast: WeatherForecastModel(
                forecastday: [
                    WeatherForecastDayModel(
                        date: "01-02-2025",
                        day: ForecastDayModel(
                            avgtempC: 20.0,
                            condition: WeatherConditionModel(
                                text: "Sunny",
                                icon: "//example.com/sunny.png"
                            )
                        )
                    ), WeatherForecastDayModel(
                        date: "02-02-2025",
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
