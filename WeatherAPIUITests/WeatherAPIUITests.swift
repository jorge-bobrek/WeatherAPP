//
//  WeatherAPIUITests.swift
//  WeatherAPIUITests
//
//  Created by Jorge Bobrek on 28/01/25.
//

import XCTest

class WeatherAPIAppFlowTests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--testing")
        app.launch()
    }

    func testCompleteUserFlow() {
        // 1. Search for London
        let searchBar = app.textFields["searchBar"]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5), "Search bar missing")
        searchBar.tap()
        searchBar.typeText("London\n")
        
        // 2. Verify search results
        let firstResult = app.buttons["locationRow_1"]
        XCTAssertTrue(firstResult.waitForExistence(timeout: 5), "No results found")
        
        // 3. Add to favorites
        let favoriteButton = firstResult.buttons["favoriteButton_1"]
        favoriteButton.tap()
        
        // 4. Go to Favorites tab
        app.buttons["tabButton_1"].tap()
        
        // 5. Verify in favorites
        let favoriteItem = app.buttons["locationRow_1"]
        XCTAssertTrue(favoriteItem.exists, "London not in favorites")
        
        // 6. Open forecast
        favoriteItem.tap()
        
        // 7. Verify carousel
        let firstCard = app.staticTexts["carouselItem_0"]
        XCTAssertTrue(firstCard.exists, "First card missing")
    }
}
