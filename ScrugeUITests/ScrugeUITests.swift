//
//  ScrugeUITests.swift
//  ScrugeUITests
//
//  Created by ysoftware on 05/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import XCTest
import Foundation
@testable import Scruge

class ScrugeUITests: XCTestCase {

	let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testLogin() {

		// open login
		app.tabBars.buttons["Profile"].tap()

		login()

		// check name
		XCTAssert(app.staticTexts["UI Tester"].waitForExistence(timeout: 3))
    }
 
	func testProfileEdit() {
		let randomString = "\(arc4random())"

		// open login/profile
		app.tabBars.buttons["Profile"].tap()

		// if not logged in
		if !app.staticTexts["UI Tester"].waitForExistence(timeout: 3) {
			login()
		}

		app.navigationBars["Scruge.ProfileView"].children(matching: .button).element.tap()
		app.buttons["Edit Profile"].tap()

		let elementsQuery = app.scrollViews.otherElements

		elementsQuery.textFields["Full Name"].tap()
		elementsQuery.textFields["Location"].tap()

		let aboutField = elementsQuery.textFields["About you"]
		aboutField.tap()
		aboutField.clearAndEnterText(text: randomString)

		elementsQuery.buttons["EDIT PROFILE"].tap()
		app.navigationBars["Settings"].buttons["Back"].tap()

		XCTAssert(app.staticTexts[randomString].waitForExistence(timeout: 3))
	}

	func login() {
		let elementsQuery = app.scrollViews.otherElements

		// type email
		let loginField = elementsQuery.textFields["Email address"]
		loginField.tap()
		loginField.typeText("test@scruge.world")

		// type password
		let passwordField = elementsQuery.secureTextFields["Password"]
		passwordField.tap()
		passwordField.typeText("123123123")

		// login
		elementsQuery.buttons["LOG IN"].tap()
	}
}
