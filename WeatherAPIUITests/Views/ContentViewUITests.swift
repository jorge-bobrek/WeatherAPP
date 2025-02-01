//
//  ContentViewUITests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 1/02/25.
//


import XCTest

class ContentViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testTabNavigation() {
        // Verify initial tab
        let locationsTab = app.buttons["tabButton_0"]
        let favoritesTab = app.buttons["tabButton_1"]
        XCTAssertTrue(locationsTab.exists, "Locations tab should exist")
        XCTAssertTrue(favoritesTab.exists, "Locations title should appear")
        
        // Switch to Favorites tab
        favoritesTab.tap()
        
        let favoritesList = app.scrollViews["locationList"]
        XCTAssertTrue(favoritesList.waitForExistence(timeout: 5), "Favorites list should appear")
    }
}
