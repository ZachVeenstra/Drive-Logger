//
//  DriveServicesTests.swift
//  DriveLoggerTests
//
//  Created by Zach Veenstra on 5/21/24.
//

import XCTest
import CoreLocation
@testable import DriveLogger

final class DriveServicesTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMorningNightDrive() async throws {
        let driveServices = await DriveViewModel()

        let driveStartComponents = DateComponents(year: 2024,
                                                  month: 5,
                                                  day: 21,
                                                  hour: 3,
                                                  minute: 0,
                                                  second: 0
        )
        let driveStart = Calendar.current.date(from: driveStartComponents)!

        let driveEndComponents = DateComponents(year: 2024,
                                                month: 5,
                                                day: 21,
                                                hour: 3,
                                                minute: 0,
                                                second: 1
      )
        let driveEnd = Calendar.current.date(from: driveEndComponents)!

        let driveInterval = DateInterval(start: driveStart, end: driveEnd)

        let latitude = CLLocationDegrees(floatLiteral: 42.96508789)
        let longitude = CLLocationDegrees(floatLiteral: -85.66231030)
        let grandRapidsLocation = CLLocation(latitude: latitude, longitude: longitude)

        let nightDuration = try await driveServices.getNightInterval(driveStart: driveStart, driveEnd: driveEnd, location: grandRapidsLocation)

        let expectedNightDuration = TimeInterval(integerLiteral: 1)

        XCTAssertEqual(expectedNightDuration, nightDuration)
    }

    func testMorningPartialNightDrive() async throws {
        let driveServices = await DriveViewModel()

        let driveStartComponents = DateComponents(year: 2024,
                                                  month: 5,
                                                  day: 21,
                                                  hour: 5,
                                                  minute: 43,
                                                  second: 26
        )
        let driveStart = Calendar.current.date(from: driveStartComponents)!

        let driveEndComponents = DateComponents(year: 2024,
                                                month: 5,
                                                day: 21,
                                                hour: 5,
                                                minute: 43,
                                                second: 40
      )
        let driveEnd = Calendar.current.date(from: driveEndComponents)!

        let driveInterval = DateInterval(start: driveStart, end: driveEnd)

        let latitude = CLLocationDegrees(floatLiteral: 42.96508789)
        let longitude = CLLocationDegrees(floatLiteral: -85.66231030)
        let grandRapidsLocation = CLLocation(latitude: latitude, longitude: longitude)

        let nightDuration = try await driveServices.getNightInterval(driveStart: driveStart, driveEnd: driveEnd, location: grandRapidsLocation)

        let expectedNightDuration = TimeInterval(integerLiteral: 2)

        XCTAssertEqual(expectedNightDuration, nightDuration)
    }

    func testDayDrive() async throws {
        let driveServices = await DriveViewModel()

        let driveStartComponents = DateComponents(year: 2024,
                                                  month: 5,
                                                  day: 21,
                                                  hour: 6,
                                                  minute: 43,
                                                  second: 26
        )
        let driveStart = Calendar.current.date(from: driveStartComponents)!

        let driveEndComponents = DateComponents(year: 2024,
                                                month: 5,
                                                day: 21,
                                                hour: 6,
                                                minute: 43,
                                                second: 40
      )
        let driveEnd = Calendar.current.date(from: driveEndComponents)!

        let driveInterval = DateInterval(start: driveStart, end: driveEnd)

        let latitude = CLLocationDegrees(floatLiteral: 42.96508789)
        let longitude = CLLocationDegrees(floatLiteral: -85.66231030)
        let grandRapidsLocation = CLLocation(latitude: latitude, longitude: longitude)

        let nightDuration = try await driveServices.getNightInterval(driveStart: driveStart, driveEnd: driveEnd, location: grandRapidsLocation)

        let expectedNightDuration = TimeInterval(integerLiteral: 0)

        XCTAssertEqual(expectedNightDuration, nightDuration)
    }

    func testEveningPartialNightDrive() async throws {
        let driveServices = await DriveViewModel()

        let driveStartComponents = DateComponents(year: 2024,
                                                  month: 5,
                                                  day: 21,
                                                  hour: 21,
                                                  minute: 35,
                                                  second: 50
        )
        let driveStart = Calendar.current.date(from: driveStartComponents)!

        let driveEndComponents = DateComponents(year: 2024,
                                                month: 5,
                                                day: 21,
                                                hour: 21,
                                                minute: 35,
                                                second: 59
      )
        let driveEnd = Calendar.current.date(from: driveEndComponents)!

        let driveInterval = DateInterval(start: driveStart, end: driveEnd)

        let latitude = CLLocationDegrees(floatLiteral: 42.96508789)
        let longitude = CLLocationDegrees(floatLiteral: -85.66231030)
        let grandRapidsLocation = CLLocation(latitude: latitude, longitude: longitude)

        let nightDuration = try await driveServices.getNightInterval(driveStart: driveStart, driveEnd: driveEnd, location: grandRapidsLocation)

        let expectedNightDuration = TimeInterval(integerLiteral: 4)

        XCTAssertEqual(expectedNightDuration, nightDuration)
    }

    func testEveningNightDrive() async throws {
        let driveServices = await DriveViewModel()

        let driveStartComponents = DateComponents(year: 2024,
                                                  month: 5,
                                                  day: 21,
                                                  hour: 21,
                                                  minute: 36,
                                                  second: 0
        )
        let driveStart = Calendar.current.date(from: driveStartComponents)!

        let driveEndComponents = DateComponents(year: 2024,
                                                month: 5,
                                                day: 21,
                                                hour: 21,
                                                minute: 36,
                                                second: 59
      )
        let driveEnd = Calendar.current.date(from: driveEndComponents)!

        let driveInterval = DateInterval(start: driveStart, end: driveEnd)

        let latitude = CLLocationDegrees(floatLiteral: 42.96508789)
        let longitude = CLLocationDegrees(floatLiteral: -85.66231030)
        let grandRapidsLocation = CLLocation(latitude: latitude, longitude: longitude)

        let nightDuration = try await driveServices.getNightInterval(driveStart: driveStart, driveEnd: driveEnd, location: grandRapidsLocation)

        let expectedNightDuration = TimeInterval(integerLiteral: 59)

        XCTAssertEqual(expectedNightDuration, nightDuration)
    }

    func testEveningNightDriveTwoDay() async throws {
        let driveServices = await DriveViewModel()

        let driveStartComponents = DateComponents(year: 2024,
                                                  month: 5,
                                                  day: 21,
                                                  hour: 23,
                                                  minute: 59,
                                                  second: 50
        )
        let driveStart = Calendar.current.date(from: driveStartComponents)!

        let driveEndComponents = DateComponents(year: 2024,
                                                month: 5,
                                                day: 22,
                                                hour: 0,
                                                minute: 0,
                                                second: 5
      )
        let driveEnd = Calendar.current.date(from: driveEndComponents)!

        let driveInterval = DateInterval(start: driveStart, end: driveEnd)

        let latitude = CLLocationDegrees(floatLiteral: 42.96508789)
        let longitude = CLLocationDegrees(floatLiteral: -85.66231030)
        let grandRapidsLocation = CLLocation(latitude: latitude, longitude: longitude)

        let nightDuration = try await driveServices.getNightInterval(driveStart: driveStart, driveEnd: driveEnd, location: grandRapidsLocation)

        let expectedNightDuration = TimeInterval(integerLiteral: 15)

        XCTAssertEqual(expectedNightDuration, nightDuration)
    }

    func testEarlyMorningToLateEvening() async throws {
        let driveServices = await DriveViewModel()

        let driveStartComponents = DateComponents(year: 2024,
                                                  month: 5,
                                                  day: 21,
                                                  hour: 5,
                                                  minute: 43,
                                                  second: 27
        )
        let driveStart = Calendar.current.date(from: driveStartComponents)!

        let driveEndComponents = DateComponents(year: 2024,
                                                month: 5,
                                                day: 21,
                                                hour: 21,
                                                minute: 35,
                                                second: 56
      )
        let driveEnd = Calendar.current.date(from: driveEndComponents)!

        let driveInterval = DateInterval(start: driveStart, end: driveEnd)

        let latitude = CLLocationDegrees(floatLiteral: 42.96508789)
        let longitude = CLLocationDegrees(floatLiteral: -85.66231030)
        let grandRapidsLocation = CLLocation(latitude: latitude, longitude: longitude)

        let nightDuration = try await driveServices.getNightInterval(driveStart: driveStart, driveEnd: driveEnd, location: grandRapidsLocation)

        let expectedNightDuration = TimeInterval(integerLiteral: 2)

        XCTAssertEqual(expectedNightDuration, nightDuration)
    }
}
