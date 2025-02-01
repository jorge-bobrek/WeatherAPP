//
//  FavoritesViewUITests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 1/02/25.
//


import XCTest

class FavoritesViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--testing")
        app.launch()
    }

    func testFavoritesList() {
        app.buttons["tabButton_1"].tap()
        
        let favoritesList = app.scrollViews["locationList"]
        XCTAssertTrue(favoritesList.waitForExistence(timeout: 5), "Favorites list should exist")
        
        // Test with mock data
        let firstFavorite = app.buttons["locationRow_0"]
        XCTAssertTrue(firstFavorite.exists, "First favorite location should exist")
    }
}
