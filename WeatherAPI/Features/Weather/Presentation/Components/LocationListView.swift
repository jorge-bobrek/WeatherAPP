//
//  LocationListView.swift
//  archetype
//
//  Created by Jorge Bobrek on 31/01/25.
//

import SwiftUI

struct LocationListView: View {
    @EnvironmentObject var favoritesStore: FavoritesStore
    @Environment(\.dependencyContainer) private var dependencyContainer
    @State private var selectedLocation: LocationModel? = nil
    var list: [LocationModel]
    
    var body: some View {
        ScrollView {
            ForEach(list, id: \.self) { location in
                Button {
                    selectedLocation = location
                } label: {
                    VStack(spacing: 2) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(location.name)
                                Text(location.country)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button {
                                Task { await favoritesStore.toggleFavorite(location) }
                            } label: {
                                Image(systemName: favoritesStore.isFavorite(location) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                        }
                        Divider()
                    }
                }
            }
        }
        .background(
            NavigationLink(
                destination: Group {
                    if let location = selectedLocation {
                        ForecastView(viewModel: dependencyContainer.makeForecastViewModel(), location: location)
                    }
                },
                isActive: Binding(
                    get: { selectedLocation != nil },
                    set: { if !$0 { selectedLocation = nil } }
                ),
                label: { EmptyView() }
            )
        )
    }
}
