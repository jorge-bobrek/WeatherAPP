//
//  FavoritesStore.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 29/01/25.
//

import SwiftUI
import CoreData

@MainActor
class FavoritesStore: ObservableObject {
    @Published var favorites: [LocationModel] = []
    @Published var error: Error?
    @Published var isLoading: Bool = false
    
    private let fetchFavoritesUseCase: FetchFavoritesUseCase
    private let addFavoriteUseCase: AddFavoriteUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    
    init(
        fetchFavoritesUseCase: FetchFavoritesUseCase,
        addFavoriteUseCase: AddFavoriteUseCase,
        removeFavoriteUseCase: RemoveFavoriteUseCase
    ) {
        self.fetchFavoritesUseCase = fetchFavoritesUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
    }
    
    func fetchFavorites() async {
        isLoading = true
        error = nil
        do {
            self.favorites = try await self.fetchFavoritesUseCase.execute()
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    func toggleFavorite(_ location: LocationModel) async {
        isLoading = true
        error = nil
        do {
            if let favorite = self.favorites.first(where: { $0.id == location.id }) {
                try await self.removeFavoriteUseCase.execute(favorite)
                if let index = favorites.firstIndex(of: favorite) {
                    self.favorites.remove(at: index)
                }
            } else {
                try await self.addFavoriteUseCase.execute(location)
                self.favorites.append(location)
            }
        } catch {
            self.error = error
        }
        isLoading = false
    }
    
    func isFavorite(_ location: LocationModel) -> Bool {
        self.favorites.contains { $0.id == location.id }
    }
}
