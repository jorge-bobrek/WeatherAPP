//
//  WeatherAPIApp.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 28/01/25.
//

import SwiftUI

@main
struct WeatherAPIApp: App {
    let dependencyContainer: DependencyContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.dependencyContainer, dependencyContainer)
                .environmentObject(dependencyContainer.makeFavoritesStore())
        }
    }
    
    init() {
        if ProcessInfo.processInfo.arguments.contains("--testing") {
            self.dependencyContainer = DependencyContainer(locationsRepository: MockLocationsRepository(), favoritesRepository: MockFavoritesRepository(), forecastRepository: MockForecastRepository())
        } else {
            self.dependencyContainer = DependencyContainer()
        }
    }
}
