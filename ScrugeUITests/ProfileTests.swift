//
//  ScrugeUITests.swift
//  ScrugeUITests
//
//  Created by ysoftware on 05/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import XCTest

class ProfileTests: XCTestCase {

	let app = XCUIApplication()
	let username = "UI Tester"

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testLogin() {

		// open login
		app.tabBars.buttons["Profile"].tap()

		login()

		// check name
		XCTAssert(app.staticTexts[username].waitForExistence(timeout: 3))
    }
 
	func testProfileEdit() {
		let randomString = "\(arc4random())"
		let elementsQuery = app.scrollViews.otherElements

		// open login/profile
		app.tabBars.buttons["Profile"].tap()

		// if not logged in
		if !app.staticTexts[username].waitForExistence(timeout: 3) {
			login()
		}

		// go to settings
		app.navigationBars["Scruge.ProfileView"].children(matching: .button).element.tap()

		// edit profile
		app.buttons["Edit Profile"].tap()

		// click through these fields just to make sure they exist
		elementsQuery.textFields["Full Name"].tap()
		elementsQuery.textFields["Location"].tap()

		// change about text
		let aboutField = elementsQuery.textFields["About you"]
		aboutField.tap()
		aboutField.clearAndEnterText(text: randomString)

		// save
		elementsQuery.buttons["EDIT PROFILE"].tap()

		// go back
		app.navigationBars["Settings"].buttons["Back"].tap()

		// check new about text
		XCTAssert(app.staticTexts[randomString].waitForExistence(timeout: 3))
	}

	// MARK: - Methods

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
