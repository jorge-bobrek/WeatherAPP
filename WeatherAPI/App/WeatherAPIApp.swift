//
//  WeatherAPIApp.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 28/01/25.
//

import SwiftUI

@main
struct WeatherAPIApp: App {
    @StateObject var favoritesStore = FavoritesStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesStore)
        }
    }
}
