//
//  FavoritesStoreTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 31/01/25.
//

import XCTest
@testable import WeatherAPI

@MainActor
final class FavoritesStoreTests: XCTestCase {
    var store: FavoritesStore!
    var mockFetchFavoritesUseCase: MockFetchFavoritesUseCase!
    var mockAddFavoriteUseCase: MockAddFavoriteUseCase!
    var mockRemoveFavoriteUseCase: MockRemoveFavoriteUseCase!
    var mockFavoritesRepository: MockFavoritesRepository!

    override func setUp() {
        super.setUp()
        mockFavoritesRepository = MockFavoritesRepository()
        mockFetchFavoritesUseCase = MockFetchFavoritesUseCase(repository: mockFavoritesRepository)
        mockAddFavoriteUseCase = MockAddFavoriteUseCase(repository: mockFavoritesRepository)
        mockRemoveFavoriteUseCase = MockRemoveFavoriteUseCase(repository: mockFavoritesRepository)
        store = FavoritesStore(
            fetchFavoritesUseCase: mockFetchFavoritesUseCase,
            addFavoriteUseCase: mockAddFavoriteUseCase,
            removeFavoriteUseCase: mockRemoveFavoriteUseCase
        )
    }

    override func tearDown() {
        store = nil
        mockFetchFavoritesUseCase = nil
        mockAddFavoriteUseCase = nil
        mockRemoveFavoriteUseCase = nil
        super.tearDown()
    }

    func testInitialState() {
        // Assert
        XCTAssertTrue(store.favorites.isEmpty, "The favorites should be empty initially.")
        XCTAssertNil(store.error, "The error should be nil initially.")
        XCTAssertFalse(store.isLoading, "The loading state should be false initially.")
    }
    func testFetchFavoritesSuccess() async {
        // Arrange
        let expectedFavorites = [
            LocationModel(id: 1, name: "London", country: "United Kingdom"),
            LocationModel(id: 2, name: "Cucuta", country: "Colombia")
        ]
        mockFetchFavoritesUseCase.fetchFavoritesResult = .success(expectedFavorites)

        // Act
        await store.fetchFavorites()

        // Assert
        XCTAssertEqual(store.favorites, expectedFavorites, "The favorites should match the expected favorites.")
        XCTAssertNil(store.error, "The error should be nil.")
        XCTAssertFalse(store.isLoading, "The loading state should be false.")
    }

    func testFetchFavoritesFailure() async {
        // Arrange
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockFetchFavoritesUseCase.fetchFavoritesResult = .failure(expectedError)

        // Act
        await store.fetchFavorites()

        // Assert
        XCTAssertTrue(store.favorites.isEmpty, "The favorites should be empty.")
        XCTAssertEqual(store.error as? NSError, expectedError, "The error should match the expected error.")
        XCTAssertFalse(store.isLoading, "The loading state should be false.")
    }

    func testToggleFavoriteAddSuccess() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")

        // Act
        await store.toggleFavorite(location)

        // Assert
        XCTAssertTrue(store.favorites.contains(location), "The location should be added to favorites.")
        XCTAssertNil(store.error, "The error should be nil.")
        XCTAssertFalse(store.isLoading, "The loading state should be false.")
    }

    func testToggleFavoriteRemoveSuccess() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        store.favorites = [location]

        // Act
        await store.toggleFavorite(location)

        // Assert
        XCTAssertFalse(store.favorites.contains(location), "The location should be removed from favorites.")
        XCTAssertNil(store.error, "The error should be nil.")
        XCTAssertFalse(store.isLoading, "The loading state should be false.")
    }

    func testToggleFavoriteAddFailure() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockAddFavoriteUseCase.addFavoriteResult = .failure(expectedError)

        // Act
        await store.toggleFavorite(location)

        // Assert
        XCTAssertFalse(store.favorites.contains(location), "The location should not be added to favorites.")
        XCTAssertEqual(store.error as? NSError, expectedError, "The error should match the expected error.")
        XCTAssertFalse(store.isLoading, "The loading state should be false.")
    }

    func testToggleFavoriteRemoveFailure() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        store.favorites = [location]
        let expectedError = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockRemoveFavoriteUseCase.removeFavoriteResult = .failure(expectedError)

        // Act
        await store.toggleFavorite(location)

        // Assert
        XCTAssertTrue(store.favorites.contains(location), "The location should not be removed from favorites.")
        XCTAssertEqual(store.error as? NSError, expectedError, "The error should match the expected error.")
        XCTAssertFalse(store.isLoading, "The loading state should be false.")
    }

    func testToggleFavoriteAddDuplicate() async {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        store.favorites = [location]

        // Act
        await store.toggleFavorite(location)

        // Assert
        XCTAssertFalse(store.favorites.contains(location), "The duplicate location should not be added.")
        XCTAssertNil(store.error, "The error should be nil.")
        XCTAssertFalse(store.isLoading, "The loading state should be false.")
    }

    func testIsFavorite() {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")
        store.favorites = [location]

        // Act & Assert
        XCTAssertTrue(store.isFavorite(location), "The location should be a favorite.")
    }

    func testIsNotFavorite() {
        // Arrange
        let location = LocationModel(id: 1, name: "London", country: "United Kingdom")

        // Act & Assert
        XCTAssertFalse(store.isFavorite(location), "The location should not be a favorite.")
    }
}
