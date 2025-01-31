//
//  FetchFavoritesUseCase.swift
//  archetype
//
//  Created by Jorge Bobrek on 31/01/25.
//

class FetchFavoritesUseCase {
    private let repository: AnyFavoritesRepository
    
    init(repository: AnyFavoritesRepository = FavoritesRepository()) {
        self.repository = repository
    }

    func execute() throws -> [LocationModel] {
        try repository.fetchFavorites()
    }
}
