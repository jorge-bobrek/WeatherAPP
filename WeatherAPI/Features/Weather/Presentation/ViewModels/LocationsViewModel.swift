//
//  LocationsViewModel.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 28/01/25.
//

import SwiftUI

@MainActor
class LocationsViewModel: ObservableObject {
    @Published var locations: [LocationModel] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var searchQuery: String = ""

    private let fetchLocationsUseCase: FetchLocationsUseCase

    init(fetchLocationsUseCase: FetchLocationsUseCase) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
    }

    func fetchLocations(query: String) async {
        if query.count > 2 {
            isLoading = true
            error = nil
            do {
                let fetchedLocations = try await fetchLocationsUseCase.execute(query: query)
                locations = fetchedLocations
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
    
}
