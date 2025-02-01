//
//  WeatherAPIApp.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 28/01/25.
//

import SwiftUI

@main
struct WeatherAPIApp: App {
    let dependencyContainer = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.dependencyContainer, dependencyContainer)
                .environmentObject(dependencyContainer.makeFavoritesStore())
        }
    }
}
