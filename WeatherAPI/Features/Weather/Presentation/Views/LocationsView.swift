//
//  SearchView.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 28/01/25.
//

import SwiftUI

struct LocationsView: View {
    @StateObject var viewModel: LocationsViewModel
    @EnvironmentObject private var favoritesStore: FavoritesStore

    var body: some View {
        VStack {
            SearchBar(searchText: $viewModel.searchQuery)
                .onChange(of: viewModel.searchQuery) { newValue in
                    Task {
                        await viewModel.fetchLocations(query: newValue)
                    }
                }
                .accessibilityIdentifier("searchBar")
            if viewModel.isLoading {
                Spacer()
                ProgressView("Cargando...")
            } else if let error = viewModel.error {
                Text("Error al obtener datos: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else {
                LocationListView(list: viewModel.locations)
            }
            Spacer()
        }
        .padding()
    }
    
    struct SearchBar: View {
        @Binding var searchText: String
        
        var body: some View {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.primary)
                    TextField("Search for a location", text: $searchText)
                        .font(.subheadline)
                        .autocorrectionDisabled()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if !searchText.isEmpty {
                        Button {
                            searchText.removeAll()
                        } label: {
                            Image(systemName: "x.circle.fill")
                        }
                        .foregroundColor(Color.secondary)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
            }
            .padding(.vertical, 1)
        }
    }
}
