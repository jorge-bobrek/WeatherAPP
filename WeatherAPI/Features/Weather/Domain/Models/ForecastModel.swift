//
//  ForecastModel.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

import Foundation

struct WeatherModel: Codable {
    let forecast: WeatherForecastModel
}

struct WeatherForecastModel: Codable {
    let forecastday: [WeatherForecastDayModel] 
}

struct WeatherForecastDayModel: Codable, Hashable {
    let date: String
    let day: ForecastDayModel
}

struct ForecastDayModel: Codable, Hashable {
    let avgtempC: Double
    let condition: WeatherConditionModel
}

struct WeatherConditionModel: Codable, Hashable {
    let text: String
    let icon: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        let url = try container.decode(String.self, forKey: .icon)
        self.icon = "https:" + url.replacingOccurrences(of: "64x64", with: "128x128")
    }
}
