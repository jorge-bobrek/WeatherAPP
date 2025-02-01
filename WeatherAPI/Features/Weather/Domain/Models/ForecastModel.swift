//
//  ForecastModel.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

import Foundation

struct WeatherModel: Codable, Equatable {
    let forecast: WeatherForecastModel
}

struct WeatherForecastModel: Codable, Equatable {
    let forecastday: [WeatherForecastDayModel]
}

struct WeatherForecastDayModel: Codable, Hashable, Equatable {
    let date: String
    let day: ForecastDayModel
}

struct ForecastDayModel: Codable, Hashable, Equatable {
    let avgtempC: Double
    let condition: WeatherConditionModel
}

struct WeatherConditionModel: Codable, Hashable, Equatable {
    let text: String
    let icon: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        let rawIconURL = try container.decode(String.self, forKey: .icon)
        self.icon = WeatherConditionModel.transformIconURL(rawIconURL)
    }

    private static func transformIconURL(_ rawURL: String) -> String {
        let sanitizedURL = rawURL.replacingOccurrences(of: "64x64", with: "128x128")
        return "https:\(sanitizedURL)"
    }

    init(text: String, icon: String) {
        self.text = text
        self.icon = WeatherConditionModel.transformIconURL(icon)
    }
}
