//
//  FavoritesView.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoritesStore: FavoritesStore
    @State private var selectedLocation: LocationModel? = nil

    var body: some View {
        LocationListView(list: favoritesStore.favorites)
            .padding()
    }
}
