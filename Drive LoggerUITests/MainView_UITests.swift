//
//  MainView_UITests.swift
//  Drive LoggerUITests
//
//  Created by Zach Veenstra
//

import XCTest

final class MainView_UITests: XCTestCase {

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

    
    func test_MainView_startDriveButton_shouldStartDrive() {
        
        // Given we are on the MainView
        app.navigationBars["Home"].staticTexts["Home"].tap()
        
        // When we tap start drive
        app.buttons["Start Drive"].tap()
        let navBar =  app.navigationBars["Drive"]
        
        // Then we should be navigated to the StartDriveView
        XCTAssert(navBar.exists)
    }
    
    func test_MainView_addDriveButton_shouldNavigateToLoggedDrivesView() {
        
        // Given we are on the MainView
        app.navigationBars["Home"].staticTexts["Home"].tap()
        
        // When we tap add drive
        app.buttons["Add Drive"].tap()
        let navBar = app.navigationBars["Logged Drives"]
        
        // Then we should be navigated to LoggedDrives
        XCTAssert(navBar.exists)
    }
    
    
    func test_MainView_totalTime_shouldUpdateWhenDriveIsLogged() {
        
        // Given we are on the MainView with a given total hours
        app.navigationBars["Home"].staticTexts["Home"].tap()
        let originalTime = app.staticTexts["TotalTime"].label

        // When we add a drive
        app.buttons["Add Drive"].tap()
        app.navigationBars["Logged Drives"].buttons["AddDriveButton"].tap()

        let minutesSlider = app.sliders["MinutesSlider"]

        minutesSlider.adjust(toNormalizedSliderPosition: getSliderValue(val: 5))

        app.collectionViews.cells.buttons["SubmitButton"].tap()
        app.navigationBars.firstMatch.buttons["Home"].tap()


        let newTime = app.staticTexts["TotalTime"].label

        // Then the total time should update
        XCTAssertNotEqual(originalTime, newTime)
               
    }
    
}

extension MainView_UITests {
    func getSliderValue(val: CGFloat) -> CGFloat {
        return CGFloat((val - 0) / (59 - 0))
    }
    
    func goToLoggedDrives() {
        app.buttons["Add Drive"].tap()
    }
}
