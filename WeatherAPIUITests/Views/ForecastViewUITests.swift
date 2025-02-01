//
//  ForecastViewUITests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 1/02/25.
//


import XCTest

class ForecastViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--testing")
        app.launch()
        
        // Navigate to forecast view
        app.buttons["tabButton_1"].tap()
        app.buttons["locationRow_0"].tap()
    }

    func testForecastElements() {
        // Verify first forecast card
        let firstCard = app.staticTexts["carouselItem_0"]
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5), "First card missing")
        
        // Test favorite button
        let favoriteButton = app.buttons["favoriteButton_0"]
        XCTAssertTrue(favoriteButton.exists, "Favorite button should exist")
        favoriteButton.tap()
        
        //Navigate back to favorites list
        let backButton = app.buttons["Back"]
        backButton.tap()
        
        //Try to find the favorite location
        XCTAssertFalse(app.staticTexts["locationRow_0"].exists, "Location should not exist anymore")
    }
}
