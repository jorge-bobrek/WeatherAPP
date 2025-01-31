//
//  LocationModel.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 28/01/25.
//

import Foundation

struct LocationModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let country: String
    
    init (id: Int, name: String, country: String) {
        self.id = id
        self.name = name
        self.country = country
    }
}
