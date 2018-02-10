//
//  SlackInterviewUITests.swift
//  SlackInterviewUITests
//
//  Created by Samuel Kitono on 6/2/18.
//  Copyright © 2018 Samuel Kitono. All rights reserved.
//

import XCTest

class SlackInterviewUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDetailNavigation() {
        
        let app = XCUIApplication()
        app.tables.staticTexts["Anthony Mathur"].tap()
        
        XCTAssertTrue(app.tables.staticTexts["anthony"].exists)
        XCTAssertTrue(app.tables.staticTexts["Anthony Mathur"].exists)
        XCTAssertTrue(app.tables.staticTexts["Development"].exists)
        XCTAssertTrue(app.tables.staticTexts["brady+ahmedexercise3@slack-corp.com"].exists)
        XCTAssertTrue(app.tables.staticTexts["123-131-2221"].exists)
        XCTAssertTrue(app.tables.staticTexts["anthonym"].exists)
        
        app.navigationBars["SlackInterview.SlackUserDetailView"].buttons["Slack Users"].tap()
    }
}

