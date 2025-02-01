//
//  ForecastView.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

import SwiftUI
import Kingfisher

struct ForecastView: View {
    @StateObject var viewModel: ForecastViewModel
    @EnvironmentObject private var favoritesStore: FavoritesStore
    let location: LocationModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else if let weather = viewModel.weather {
                CardCarouselView(items: weather.forecast.forecastday) { forecast in
                    VStack {
                        Text(DateUtils.formatDateString(forecast.date))
                            .font(.headline)
                        Text(String(format: "%.1f°C", forecast.day.avgtempC))
                            .font(.title)
                        KFImage(URL(string: forecast.day.condition.icon)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                        Text(forecast.day.condition.text)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .frame(width: 160, height: 240)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding()
                
                Spacer()
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task { await favoritesStore.toggleFavorite(location) }
                } label: {
                    Image(systemName: favoritesStore.isFavorite(location) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
                .accessibilityIdentifier("favoriteButton_\(location.id)")
            }
        }
        .navigationBarTitle(location.name, displayMode: .large)
        .onAppear {
            Task {
                await viewModel.fetchForecast(for: location, days: 3)
            }
        }
    }
}
