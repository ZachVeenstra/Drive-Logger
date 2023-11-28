//
//  DriveView_UITests.swift
//  Drive LoggerUITests
//
//  Created by Zach Veenstra
//

import XCTest

final class DriveView_UITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    
    func test_DriveView_homeButton_shouldNavigateToMainView() {
        // Given we are on the DriveView
        goToDriveView()
        
        // When the home button is tapped
        app.navigationBars.firstMatch.buttons["Home"].tap()
        let navBar = app.navigationBars["Home"]
        
        // Then we should navigate to the MainView
        XCTAssert(navBar.exists)
    }
    
    func test_DriveView_timeText_shouldUpdateWhenTimePasses() {
        // Given we are on the DriveView
        goToDriveView()
        
        // When time passes
        let timeText = app.staticTexts["0:0:3"]
        sleep(3)
        
        // Then time text should update
        XCTAssert(timeText.exists)
    }
    
    func test_DriveView_endDriveButton_shouldNavigateToMainView() {
        // Given we are on the DriveView
        goToDriveView()
        
        // When the end drive button is tapped
        app.buttons["End Drive"].tap()
        let navBar = app.navigationBars["Home"]
        
        // Then we should navigate to the MainView
        XCTAssert(navBar.exists)
    }
    
    func test_DriveView_endDriveButton_shouldLogDrive() {
        // Given we are on the DriveView
        goToDriveView()
        
        // When the end drive button is tapped
        app.buttons["End Drive"].tap()
        goToLoggedDrives()
        let drive = app.buttons["DriveElementName-DriveElementTime"].firstMatch
        
        // Then the drive should be logged
        XCTAssert(drive.exists)
    }
    
    
    //MARK: This test may fail because when other tests run before it, they populate CoreData with logged drives
    func test_DriveView_homeButton_shouldNotLogDrive() {
        // Given we are on the DriveView
        goToDriveView()
        
        // When the home button is tapped
        app.navigationBars.firstMatch.buttons["Home"].tap()
        app.buttons["Add Drive"].tap()
        
        let drive = app.buttons["DriveElementName-DriveElementTime"].firstMatch
        
        
        // Then we should not log the drive
        XCTAssert(!drive.exists)
    }
}

extension DriveView_UITests {
    func goToDriveView() {
        app.buttons["Start Drive"].tap()
    }
    
    func goToLoggedDrives() {
        app.buttons["Add Drive"].tap()
    }
    
    func goToAddDriveView() {
        goToLoggedDrives()
        app.navigationBars["Logged Drives"]/*@START_MENU_TOKEN@*/.buttons["Add drive"]/*[[".otherElements[\"Add drive\"].buttons[\"Add drive\"]",".buttons[\"Add drive\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
