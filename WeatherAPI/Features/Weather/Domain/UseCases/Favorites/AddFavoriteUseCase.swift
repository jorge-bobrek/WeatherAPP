//
//  AddFavoriteUseCase.swift
//  archetype
//
//  Created by Jorge Bobrek on 31/01/25.
//

class AddFavoriteUseCase {
    private let repository: AnyFavoritesRepository

    init(repository: AnyFavoritesRepository) {
        self.repository = repository
    }
    
    func execute(_ location: LocationModel) async throws {
        try await repository.addFavorite(location)
    }
}
