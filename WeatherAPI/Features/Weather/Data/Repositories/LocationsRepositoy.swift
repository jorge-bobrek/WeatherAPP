//
//  LocationsRepositoy.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 28/01/25.
//

import Foundation

class LocationsRepository: AnyLocationsRepository {
    private let networkService: AnyNetworkService
    
    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchLocations(query: String) async throws -> [LocationModel] {
        let searchQueryParams = ["q": query]
        return try await networkService.fetchData(endpoint: "/search", queryParams: searchQueryParams
)
    }
}
