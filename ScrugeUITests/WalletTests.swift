//
//  WalletTests.swift
//  
//
//  Created by ysoftware on 05/02/2019.
//


import XCTest

class WalletTests: XCTestCase {

	let app = XCUIApplication()
	let elementsQuery = XCUIApplication().scrollViews.otherElements

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

		// open transfers
		elementsQuery.staticTexts["Transfer"].tap()

		let receiverField = elementsQuery.textFields["Receiver"]
		receiverField.tap()
		receiverField.typeText(otherAccount)

		let amountField = elementsQuery.textFields["Amount"]
		amountField.tap()
		amountField.typeText("0.0001")

		let memoField = elementsQuery.textFields["Memo"]
		memoField.tap()
		memoField.typeText("This is a test")

		let pwdField = elementsQuery.secureTextFields["Wallet password"]
		pwdField.tap()
		pwdField.typeText(password)

		// send transaction
		elementsQuery.buttons["TRANSFER"].tap()

		// check if transaction was successful
		XCTAssert(elementsQuery.staticTexts["Transaction was successful"].waitForExistence(timeout: 3))
	}

	func testExport() {

		// open wallet
		app.tabBars.buttons["Wallet"].tap()

		importKey()

		// open wallet data
		let walletData = elementsQuery.staticTexts["Wallet Data"]
		walletData.tap()

		// press export key
		app.scrollViews
			.children(matching: .other).element
			.children(matching: .other).element
			.children(matching: .other).element(boundBy: 2)
			.children(matching: .other).element(boundBy: 2)
			.children(matching: .other).element
			.children(matching: .other).element(boundBy: 1)
			.children(matching: .other).element
			.children(matching: .other).element
			.children(matching: .other).element
			.children(matching: .other).element(boundBy: 3)
			.buttons["copy"].tap()

		// enter password in alert and press ok
		let alert = app.alerts["Export private key"]
		let pwdField = alert.secureTextFields["Wallet password"]
		pwdField.tap()
		pwdField.typeText(password)
		alert.buttons["Unlock"].tap()

		// dismiss alert with security warning
		app.buttons["OK"].tap()

		// check if key is showing
		let keyText = elementsQuery.staticTexts[key]
		XCTAssert(keyText.waitForExistence(timeout: 3))

		// close wallet data
		walletData.tap()

		// open wallet data again
		walletData.tap()

		// check if key not showing anymore
		XCTAssertFalse(keyText.waitForExistence(timeout: 3))
	}

	// MARK: - Methods

	func importKey() {

		// only import if doesn't exist already
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
