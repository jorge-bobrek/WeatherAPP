//
//  ContentView.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 28/01/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore
    @Environment(\.dependencyContainer) private var dependencyContainer
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            TabsView(selectedTab: $selectedTab, tabs: [
                TabItem(title: "Locations", icon: "magnifyingglass"),
                TabItem(title: "Favorites", icon: "star.fill")
            ]) { index in
                switch index {
                case 0:
                    LocationsView(viewModel: dependencyContainer.makeLocationsViewModel())
                case 1:
                    FavoritesView()
                default:
                    EmptyView()
                }
            }
            .onAppear {
                Task { await favoritesStore.fetchFavorites() }
            }
        }
    }
}
