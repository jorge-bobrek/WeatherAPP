//
//  APIKeyLoader.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import Foundation

struct APIKeyLoader {
    static var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let apiKey = config["API_KEY"] as? String else {
            fatalError("Unable to load API key from Config.plist")
        }
        return apiKey
    }
}
