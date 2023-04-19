//
//  AddDriveView_UITests.swift
//  Drive LoggerUITests
//
//  Created by Zach Veenstra on 4/19/23.
//

import XCTest

final class AddDriveView_UITests: XCTestCase {

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
    
    
    func test_AddDriveView_driveNameTextField_shouldSaveNameWhenEdited() {
        // Given we are on the AddDriveView
        
        // When the drive name textfield is edited
        
        // Then the name should be updated
        
    }
    
    func test_AddDriveView_secondsSlider_shouldUpdateWhenSlid() {
        // Given we are on the AddDriveView
        
        // When the seconds slider is slid
        
        // Then the seconds should be updated
        
    }
    
    func test_AddDriveView_minutesSlider_shouldUpdateWhenSlid() {
        // Given we are on the AddDriveView
        
        // When the minutes slider is slid
        
        // Then the minutes should be updated
        
    }
    
    func test_AddDriveView_hoursSlider_shouldUpdateWhenSlid() {
        // Given we are on the AddDriveView
        
        // When the hours slider is slid
        
        // Then the hours should be updated
        
    }
    
    func test_AddDriveView_driveDistanceTextfield_shouldUpdateWhenEdited() {
        // Given we are on the AddDriveView
        
        // When the drive distance textfield is edited
        
        // Then the distance should be updated
        
    }
    
    func test_AddDriveView_submitButton_shouldNavigateToLoggedDrives() {
        
        // Given we are on the AddDriveView
        goToAddDriveView()
        
        // When we tap the submit button
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Submit"]/*[[".cells.buttons[\"Submit\"]",".buttons[\"Submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let navBar = app.navigationBars["Logged Drives"]
        
        // Then we should navigate to the LoggedDrives view
        XCTAssert(navBar.exists)
    }
    
    func test_AddDriveView_submitButton_shouldLogDrive() {
        
        // Given we are on the AddDriveView
        goToAddDriveView()
        
        // When we tap the submit button
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Name"]/*[[".cells.textFields[\"Name\"]",".textFields[\"Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        for _ in 0...20 {
            deleteKey.tap()
        }
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Name"]/*[[".cells.textFields[\"Name\"]",".textFields[\"Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        for _ in 0...10 {
            deleteKey.tap()
        }
        
        let TKey = app/*@START_MENU_TOKEN@*/.keys["T"]/*[[".keyboards.keys[\"T\"]",".keys[\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        TKey.tap()
        
        let eKey = app/*@START_MENU_TOKEN@*/.keys["e"]/*[[".keyboards.keys[\"e\"]",".keys[\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        eKey.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        
        let tKey = app/*@START_MENU_TOKEN@*/.keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Submit"]/*[[".cells.buttons[\"Submit\"]",".buttons[\"Submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let button = collectionViewsQuery.buttons["Testa, 0hrs  0mins"]
        
        // Then the drive should be logged
        XCTAssert(button.exists)
    }
    
    func test_AddDriveView_slideDownAction_shouldNavigateToLoggedDrives() {
        // Given we are on the AddDriveView
        
        // When we slide down
        
        // Then we should navigate to the LoggedDrives view
        
    }
    
    func test_AddDriveView_slideDownAction_shouldNotLogDrive() {
        // Given we are on the AddDriveView
        
        // When we slide down
        
        // Then we should log the drive
        
    }
}

extension AddDriveView_UITests {
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
