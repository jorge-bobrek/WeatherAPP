//
//  DependencyContainer.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

final class DependencyContainer {
    // MARK: - Properties

    private let locationsRepository: AnyLocationsRepository
    private let favoritesRepository: AnyFavoritesRepository
    private let forecastRepository: AnyForecastRepository

    // MARK: - Initializer

    init(
        locationsRepository: AnyLocationsRepository = LocationsRepository(networkService: NetworkService.shared),
        favoritesRepository: AnyFavoritesRepository = FavoritesRepository(persistence: PersistenceManager.shared),
        forecastRepository: AnyForecastRepository = ForecastRepository(networkService: NetworkService.shared)
    ) {
        self.locationsRepository = locationsRepository
        self.favoritesRepository = favoritesRepository
        self.forecastRepository = forecastRepository
    }

    // MARK: - Use Cases

    func makeFetchLocationsUseCase() -> FetchLocationsUseCase {
        FetchLocationsUseCase(repository: locationsRepository)
    }

    func makeFetchFavoritesUseCase() -> FetchFavoritesUseCase {
        FetchFavoritesUseCase(repository: favoritesRepository)
    }

    func makeAddFavoriteUseCase() -> AddFavoriteUseCase {
        AddFavoriteUseCase(repository: favoritesRepository)
    }

    func makeRemoveFavoriteUseCase() -> RemoveFavoriteUseCase {
        RemoveFavoriteUseCase(repository: favoritesRepository)
    }

    func makeFetchForecastUseCase() -> FetchForecastUseCase {
        FetchForecastUseCase(repository: forecastRepository)
    }

    // MARK: - Stores

    @MainActor func makeFavoritesStore() -> FavoritesStore {
        FavoritesStore(
            fetchFavoritesUseCase: makeFetchFavoritesUseCase(),
            addFavoriteUseCase: makeAddFavoriteUseCase(),
            removeFavoriteUseCase: makeRemoveFavoriteUseCase()
        )
    }
    
    // MARK: - ViewModels

    @MainActor func makeLocationsViewModel() -> LocationsViewModel {
        LocationsViewModel(fetchLocationsUseCase: makeFetchLocationsUseCase())
    }
    
    @MainActor func makeForecastViewModel() -> ForecastViewModel {
        ForecastViewModel(fetchForecastUseCase: makeFetchForecastUseCase())
    }
}
