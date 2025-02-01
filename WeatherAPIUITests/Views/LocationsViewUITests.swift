//
//  LocationsViewUITests.swift
//  WeatherAPI
//
//  Created by Jorge Bobrek on 1/02/25.
//


import XCTest

class LocationsViewUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--testing")
        app.launch()
    }

    func testSearchFlow() {
        let searchBar = app.textFields["searchBar"]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5), "Search bar missing")
        
        // Perform search
        searchBar.tap()
        searchBar.typeText("London\n")
        
        // Verify results
        let resultsList = app.scrollViews["locationList"]
        XCTAssertTrue(resultsList.waitForExistence(timeout: 5), "Results list should appear")
        
        // Test result interaction
        let firstResult = app.buttons["locationRow_1"]
        XCTAssertTrue(firstResult.exists, "First result should exist")
        firstResult.tap()
        
        // Verify navigation to forecast
        XCTAssertTrue(app.navigationBars["London"].exists, "Should navigate to forecast")
    }
}
