//
//  WalletTests.swift
//  
//
//  Created by ysoftware on 05/02/2019.
//


import XCTest

class WalletTests: XCTestCase {

	let app = XCUIApplication()

	let key = "5KdYZnaKk9KmQkdfENASqeGrwiPqsjANGPTdT2f2An8XUy58YZR"
	let account = "testaccountp"
	let otherAccount = "testaccountd"
	let password = "1234567890"

	override func setUp() {
		continueAfterFailure = false
		app.launchArguments = [LaunchArgs.EosTestNodeArgument]
		app.launch()
	}

	func testKeyImport() {

		// open wallet
		app.tabBars.buttons["Wallet"].tap()

		removeKey()

		importKey()

		// check if account and balance loaded
		XCTAssert(app.staticTexts[account].waitForExistence(timeout: 3))
	}

	func testTransaction() {

		// open wallet
		app.tabBars.buttons["Wallet"].tap()

		importKey()


	}

	// MARK: - Methods

	func importKey() {
		let elementsQuery = app.scrollViews.otherElements

		let importButton = app.buttons["IMPORT KEY"]
		guard importButton.waitForExistence(timeout: 3) else { return }

		// import key
		importButton.tap()

		// enter the key
		let privateKeySecureTextField = elementsQuery.secureTextFields["Private key"]
		privateKeySecureTextField.tap()
		privateKeySecureTextField.typeText(key)

		// enter new password
		let newWalletPasswordSecureTextField = elementsQuery.secureTextFields["New wallet password"]
		newWalletPasswordSecureTextField.tap()
		newWalletPasswordSecureTextField.typeText(password)

		// import
		elementsQuery.buttons["IMPORT KEY"].tap()
	}

	func removeKey() {
		let elementsQuery = app.scrollViews.otherElements

		// remove key if no account page
		let removeKey = elementsQuery.buttons["Remove key and start over"]
		let gear = app.scrollViews.otherElements.buttons["gear"]

		if removeKey.waitForExistence(timeout: 2) {
			removeKey.tap()
			app.buttons["YES"].tap()
		}
			// remove key if account loaded
		else if gear.waitForExistence(timeout: 2) {
			gear.tap()
			app.sheets["Select action"].buttons["Delete Wallet"].tap()
			app.buttons["YES"].tap()
		}
	}
}
