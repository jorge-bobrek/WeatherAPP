//
//  NetworkServiceTests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 1/02/25.
//

import XCTest
@testable import WeatherAPI

final class NetworkServiceTests: XCTestCase {
    var networkService: NetworkService!

    override func setUp() {
        super.setUp()
        networkService = NetworkService.shared
    }

    override func tearDown() {
        networkService = nil
        super.tearDown()
    }

    // MARK: - Success Case

    func testFetchDataSuccess() async {
        // Arrange
        let mockNetworkService = MockNetworkService()
        let expectedData = WeatherModel(forecast: WeatherForecastModel(forecastday: []))
        mockNetworkService.fetchDataResult = .success(expectedData)

        // Act & Assert
        do {
            let result: WeatherModel = try await mockNetworkService.fetchData(endpoint: "forecast", queryParams: [:])
            XCTAssertEqual(result, expectedData, "The fetched data should match the expected data.")
        } catch {
            XCTFail("Fetching data should not fail: \(error)")
        }
    }

    // MARK: - Failure Cases

    func testFetchDataInvalidURL() async {
        // Arrange
        let mockNetworkService = MockNetworkService()
        mockNetworkService.fetchDataResult = .failure(NetworkError.invalidURL(urlString: "invalid-url"))

        // Act & Assert
        do {
            let _: WeatherModel = try await mockNetworkService.fetchData(endpoint: "forecast", queryParams: [:])
            XCTFail("Fetching data should fail with an invalid URL.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.invalidURL(urlString: "invalid-url"), "The error should be invalidURL.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchDataDecodingFailed() async {
        // Arrange
        let mockNetworkService = MockNetworkService()
        let decodingError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid data"))
        mockNetworkService.fetchDataResult = .failure(NetworkError.decodingFailed(type: "WeatherModel", innerError: decodingError))

        // Act & Assert
        do {
            let _: WeatherModel = try await mockNetworkService.fetchData(endpoint: "forecast", queryParams: [:])
            XCTFail("Fetching data should fail with a decoding error.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.decodingFailed(type: "WeatherModel", innerError: decodingError), "The error should be decodingFailed.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchDataNoInternetConnection() async {
        // Arrange
        let mockNetworkService = MockNetworkService()
        mockNetworkService.fetchDataResult = .failure(NetworkError.noInternetConnection)

        // Act & Assert
        do {
            let _: WeatherModel = try await mockNetworkService.fetchData(endpoint: "forecast", queryParams: [:])
            XCTFail("Fetching data should fail with no internet connection.")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.noInternetConnection, "The error should be noInternetConnection.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
