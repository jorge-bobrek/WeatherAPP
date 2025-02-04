//
//  FetchFavoritesUseCase.swift
//  archetype
//
//  Created by Jorge Bobrek on 31/01/25.
//

class FetchFavoritesUseCase {
    private let repository: AnyFavoritesRepository

    init(repository: AnyFavoritesRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [LocationModel] {
        try await repository.fetchFavorites()
    }
}
