//
//  MockRemoveFavoriteUseCase.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//


import Foundation
@testable import WeatherAPI

final class MockRemoveFavoriteUseCase: RemoveFavoriteUseCase {
    var removeFavoriteResult: Result<Void, Error> = .success(())
    
    override func execute(_ location: LocationModel) async throws {
        switch removeFavoriteResult {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
