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
    
    private let fetchFavoritesUseCase: FetchFavoritesUseCase
    private let addFavoritesUseCase: AddFavoritesUseCase
    private let removeFavoritesUseCase: RemoveFavoritesUseCase
    
    init(fetchFavoritesUseCase: FetchFavoritesUseCase = FetchFavoritesUseCase(), addFavoritesUseCase: AddFavoritesUseCase = AddFavoritesUseCase(), removeFavoritesUseCase: RemoveFavoritesUseCase = RemoveFavoritesUseCase()) {
        self.fetchFavoritesUseCase = fetchFavoritesUseCase
        self.addFavoritesUseCase = addFavoritesUseCase
        self.removeFavoritesUseCase = removeFavoritesUseCase
    }
    
    func fetchFavorites() {
        do {
            self.favorites = try self.fetchFavoritesUseCase.execute()
        } catch {
            self.error = error
        }
    }
    
    func toggleFavorite(_ location: LocationModel) {
        do {
            if let favorite = self.favorites.first(where: { $0.id == location.id }) {
                try self.removeFavoritesUseCase.execute(favorite)
                if let index = favorites.firstIndex(of: favorite) {
                    self.favorites.remove(at: index)
                } else {
                    self.fetchFavorites()
                }
            } else {
                try self.addFavoritesUseCase.execute(location)
                self.favorites.append(location)
            }
        } catch {
            self.error = error
        }
    }
    
    func isFavorite(_ location: LocationModel) -> Bool {
        self.favorites.contains { $0.id == location.id }
    }
    
}
