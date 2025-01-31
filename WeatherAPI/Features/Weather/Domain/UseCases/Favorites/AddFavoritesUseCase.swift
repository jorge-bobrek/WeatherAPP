//
//  AddFavoritesUseCase.swift
//  archetype
//
//  Created by Jorge Bobrek on 31/01/25.
//

class AddFavoritesUseCase {
    private let repository: AnyFavoritesRepository
    
    init(repository: AnyFavoritesRepository = FavoritesRepository()) {
        self.repository = repository
    }

    func execute(_ location: LocationModel) throws {
        try repository.addFavorite(location)
    }
}
