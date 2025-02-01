//
//  MockFetchFavoritesUseCase.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import Foundation
@testable import WeatherAPI

final class MockFetchFavoritesUseCase: FetchFavoritesUseCase {
    var fetchFavoritesResult: Result<[LocationModel], Error> = .success([])
    
    override func execute() async throws -> [LocationModel] {
        switch fetchFavoritesResult {
        case .success(let favorites):
            return favorites
        case .failure(let error):
            throw error
        }
    }
}
