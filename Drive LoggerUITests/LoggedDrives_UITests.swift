//
//  LoggedDrives_UITests.swift
//  Drive LoggerUITests
//
//  Created by Zach Veenstra
//

import XCTest

final class LoggedDrives_UITests: XCTestCase {

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
    
    
    func test_LoggedDrives_homeButton_shouldNavigateToMainView() {
        // Given we are on the LoggedDrives View
        goToLoggedDrives()
        
        // When the home button is tapped
        app.navigationBars.firstMatch.buttons["Home"].tap()
        let navBar = app.navigationBars["Home"]
        
        // Then we should navigate to the MainView
        XCTAssert(navBar.exists)
        
    }
    
    func test_LoggedDrives_plusButton_shouldOpenAddDriveView() {
        
        // Given we are on the LoggedDriveView
        goToLoggedDrives()
        
        // When
        app.navigationBars["Logged Drives"]/*@START_MENU_TOKEN@*/.buttons["Add drive"]/*[[".otherElements[\"Add drive\"].buttons[\"Add drive\"]",".buttons[\"Add drive\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        let text = app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Add Drive"]/*[[".cells.staticTexts[\"Add Drive\"]",".staticTexts[\"Add Drive\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        // Then
        XCTAssert(text.exists)
    }
    
    func test_LoggedDrives_editButton_shouldShowDeleteButton() {
        // Given we are on the LoggedDrives view
        goToLoggedDrives()
        logDrive()
        
        // When the edit button is tapped
        app.navigationBars["Logged Drives"]/*@START_MENU_TOKEN@*/.buttons["Edit"]/*[[".otherElements[\"Edit\"].buttons[\"Edit\"]",".buttons[\"Edit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let removeButton = app.collectionViews.cells.otherElements.containing(.image, identifier:"remove").element
        
        // Then the delete button should be shown
        XCTAssert(removeButton.exists)
    }
    
    //
    func test_LoggedDrives_loggedDriveElement_shouldNavigateToEditDriveView() {
        // Given we are on the LoggedDrives view
            
            // Make sure there is a logged drive to tap
            goToDriveView()
            app.buttons["End Drive"].tap()
        
        goToLoggedDrives()
        
        // When a logged drive is tapped
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["DriveElementName-DriveElementTime"]/*[[".cells",".buttons[\"Drive on 4\/19\/23, 4:25 PM, 5hrs  0mins\"]",".buttons[\"DriveElementName-DriveElementTime\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        let text = app.staticTexts["Edit Drive"]
        
        // Then we should be navigated to the EditDriveView
        XCTAssert(text.exists)
    }
}

extension LoggedDrives_UITests {
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
    
    func logDrive() {
        app.navigationBars["Logged Drives"].buttons["AddDriveButton"].tap()
        
        app.collectionViews.cells.buttons["SubmitButton"].tap()
    }
}
