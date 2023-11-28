//
//  EditDriveView_UITests.swift
//  Drive LoggerUITests
//
//  Created by Zach Veenstra
//

import XCTest

final class EditDriveView_UITests: XCTestCase {

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
    
    
    func test_EditDriveView_homeButton_shouldNavigateToMainView() {
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When the home button is tapped
        app.navigationBars.firstMatch.buttons["Home"].tap()
        let navBar = app.navigationBars["Home"]
        
        // Then we should navigate to the MainView
        XCTAssert(navBar.exists)
    }
    
    func test_EditDriveView_homeButton_shouldNotSaveChanges() {
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When the home button is tapped
        let tf = app.textFields["NameField"]
        
        tf.tap()
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        for _ in 0...20 {
            deleteKey.tap()
        }
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        tf.tap()
        
        for _ in 0...10 {
            deleteKey.tap()
        }
        
        tf.typeText("Testc")
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.navigationBars.firstMatch.buttons["Home"].tap()
        goToLoggedDrives()
        app.buttons["DriveElementName-DriveElementTime"].firstMatch.tap()
        
        let text = app.textFields["NameField"].value
        
        
        // Then we should not save our changes
        XCTAssertNotEqual(text as! String, "Testc")
        
    }
    
    func test_EditDriveView_loggedDrivesButton_shouldNavigateToLoggedDrives() {
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When the logged drives button is tapped
        app.navigationBars.buttons["Logged Drives"].tap()
        let navBar = app.navigationBars["Logged Drives"]
        
        // Then we should be navigated to the LoggedDrives view
        XCTAssert(navBar.exists)
    }
    
    func test_EditDriveView_loggedDrivesButton_shouldNotSaveChanges() {
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When the logged drives button is tapped
        let tf = app.textFields["NameField"]
        
        tf.tap()
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        for _ in 0...20 {
            deleteKey.tap()
        }
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        tf.tap()
        
        for _ in 0...10 {
            deleteKey.tap()
        }
        
        tf.typeText("Testc")
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app.navigationBars.buttons["Logged Drives"].tap()
        app.buttons["DriveElementName-DriveElementTime"].firstMatch.tap()
        
        let text = app.textFields["NameField"].value
        
        // Then we should not save our changes
        XCTAssertNotEqual(text as! String, "Testc")
        
    }
    
    func test_EditDriveView_driveNameTextField_shouldSaveNameWhenEdited() {
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When the drive name textfield is edited
        let tf = app.textFields["NameField"]
        
        tf.tap()
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        for _ in 0...20 {
            deleteKey.tap()
        }
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        tf.tap()
        
        for _ in 0...10 {
            deleteKey.tap()
        }
        
        tf.typeText("Testa")
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Submit"]/*[[".cells.buttons[\"Submit\"]",".buttons[\"Submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let button = app.buttons["Testa, 0hrs  0mins"].firstMatch
        
        // Then the name should be updated
        XCTAssert(button.exists)
    }
    
    func test_EditDriveView_secondsSlider_shouldUpdateWhenSlid() {
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When the seconds slider is slid
        let secondsSlider = app.sliders["SecondsSlider"]
        secondsSlider.adjust(toNormalizedSliderPosition: getSliderValue(val: 6))
        app.collectionViews.cells.buttons["SubmitButton"].tap()
        
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["DriveElementName-DriveElementTime"]/*[[".cells",".buttons[\"Drive on 4\/19\/23, 4:25 PM, 5hrs  0mins\"]",".buttons[\"DriveElementName-DriveElementTime\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        let seconds = app.staticTexts["Seconds: 6"]
        
        // Then the seconds should be updated
        XCTAssert(seconds.exists)
    }
    
    func test_EditDriveView_minutesSlider_shouldUpdateWhenSlid() {
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When the minutes slider is slid
        let minutesSlider = app.sliders["MinutesSlider"]
        minutesSlider.adjust(toNormalizedSliderPosition: getSliderValue(val: 6))
        app.collectionViews.cells.buttons["SubmitButton"].tap()
        
        app.collectionViews/*@START_MENU_TOKEN@*/.buttons["DriveElementName-DriveElementTime"]/*[[".cells",".buttons[\"Drive on 4\/19\/23, 4:25 PM, 5hrs  0mins\"]",".buttons[\"DriveElementName-DriveElementTime\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        let minutes = app.staticTexts["Minutes: 6"]
        
        // Then the minutes should be updated
        XCTAssert(minutes.exists)
    }
    
    func test_EditDriveView_hoursSlider_shouldUpdateWhenSlid() {
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When the hours slider is slid
        let hoursSlider = app.sliders["HoursSlider"]
        hoursSlider.adjust(toNormalizedSliderPosition: getHoursSliderValue(val: 5))
        app.collectionViews.cells.buttons["SubmitButton"].tap()
        
        app.collectionViews.buttons["DriveElementName-DriveElementTime"].firstMatch.tap()
        
        let hours = app.staticTexts["Hours: 5"]
        
        // Then the hours should be updated
        XCTAssert(hours.exists)
    }
    
    func test_EditDriveView_driveDistanceTextfield_shouldUpdateWhenEdited() {
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When the drive distance textfield is edited
        app/*@START_MENU_TOKEN@*/.textFields["DistanceField"]/*[[".cells",".textFields[\"Distance\"]",".textFields[\"DistanceField\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let deleteKey = app.keys["Delete"]
        deleteKey.tap(withNumberOfTaps: 3, numberOfTouches: 3)
        
        let key = app/*@START_MENU_TOKEN@*/.keys["9"]/*[[".keyboards.keys[\"9\"]",".keys[\"9\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        
        let verticalScrollBar2PagesCollectionView = app/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 2 pages").element/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 2 pages\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        verticalScrollBar2PagesCollectionView.swipeUp()
        
        app/*@START_MENU_TOKEN@*/.buttons["SubmitButton"]/*[[".cells",".buttons[\"Submit\"]",".buttons[\"SubmitButton\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["DriveElementName-DriveElementTime"].firstMatch.tap()
        
        
        // Then the distance should be updated
        let distance = app/*@START_MENU_TOKEN@*/.textFields["DistanceField"]/*[[".cells",".textFields[\"Distance\"]",".textFields[\"DistanceField\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.value
        XCTAssertEqual(distance as! String, "9.0")
    }
    
    func test_EditDriveView_submitButton_shouldNavigateToLoggedDrives() {
        
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When we tap the submit button
        app/*@START_MENU_TOKEN@*/.buttons["Submit"]/*[[".cells.buttons[\"Submit\"]",".buttons[\"Submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let navBar = app.navigationBars["Logged Drives"]
        
        // Then we should navigate to the LoggedDrives view
        XCTAssert(navBar.exists)
    }
    
    func test_EditDriveView_submitButton_shouldLogDrive() {
        
        // Given we are on the EditDriveView
        goToEditDriveView()
        
        // When we tap the submit button
        let tf = app.textFields["NameField"]
        
        tf.tap()
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        for _ in 0...20 {
            deleteKey.tap()
        }
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        tf.tap()
        
        for _ in 0...10 {
            deleteKey.tap()
        }
        
        tf.typeText("Testb")
        
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Submit"]/*[[".cells.buttons[\"Submit\"]",".buttons[\"Submit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let button = app.buttons["Testb, 0hrs  0mins"].firstMatch
        
        // Then the drive should be logged
        XCTAssert(button.exists)
    }
    
}

extension EditDriveView_UITests {
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
    
    func goToEditDriveView() {
        goToAddDriveView()
        app.buttons["SubmitButton"].tap()
        app.buttons["DriveElementName-DriveElementTime"].firstMatch.tap()
    }
    
    func getSliderValue(val: CGFloat) -> CGFloat {
        return CGFloat((val - 0) / (59 - 0))
    }
    
    func getHoursSliderValue(val: CGFloat) -> CGFloat {
        return CGFloat((val - 0) / (50 - 0))
    }
}
