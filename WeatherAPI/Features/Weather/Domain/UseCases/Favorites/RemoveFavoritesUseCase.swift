//
//  FetchFavoritesUseCase.swift
//  archetype
//
//  Created by Jorge Bobrek on 31/01/25.
//

class RemoveFavoritesUseCase {
    private let repository: AnyFavoritesRepository
    
    init(repository: AnyFavoritesRepository = FavoritesRepository()) {
        self.repository = repository
    }

    func execute(_ location: LocationModel) throws {
        try repository.removeFavorite(location)
    }
}
