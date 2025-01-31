//
//  LocationsViewModel.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 28/01/25.
//

import SwiftUI
import Combine

@MainActor
class LocationsViewModel: ObservableObject {
    @Published var locations: [LocationModel] = []
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var searchQuery: String = ""

    private let fetchLocationsUseCase: FetchLocationsUseCase
    private var cancellables = Set<AnyCancellable>()

    init(fetchLocationsUseCase: FetchLocationsUseCase = FetchLocationsUseCase()) {
        self.fetchLocationsUseCase = fetchLocationsUseCase
    }

    func fetchLocations(query: String) async {
        isLoading = true
        defer { isLoading = false }
        do {
            error = nil
            locations = try await fetchLocationsUseCase.execute(query: query)
        } catch {
            self.error = error
        }
    }
    
}
