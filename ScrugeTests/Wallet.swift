//
//  ScrugeTests.swift
//  ScrugeTests
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest
@testable import Scruge

let PASSCODE = "123456"
let PRIVATE_KEY = "5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"

final class WalletTests: XCTestCase {

	// MARK: - Import

	func keyBlock(_ expectation:XCTestExpectation) -> (SELocalAccount?)->Void {
		return { account in
			if account != nil {
				expectation.fulfill()
			}
		}
	}

	func testGenerate() {
		let expectation = XCTestExpectation()
		expectation.expectationDescription = "key should be generated"

		Service.wallet.createKey(passcode: PASSCODE, keyBlock(expectation))
	}

	func testSuccessImport() {
		let expectation = XCTestExpectation()
		expectation.expectationDescription = "this key should be imported correctly"
		// correct private key created by keosd
		Service.wallet.importKey(PRIVATE_KEY,
								 passcode: PASSCODE, keyBlock(expectation))
		wait(for: [expectation], timeout: 3)
	}

	func testFailImport() {
		let expectation = XCTestExpectation()
		expectation.expectationDescription = "these keys should fail import"
		expectation.isInverted = true

		// public key instead of private key
		Service.wallet.importKey("EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV",
								 passcode: PASSCODE, keyBlock(expectation))
		// modified private key
		Service.wallet.importKey("5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD2",
								 passcode: PASSCODE, keyBlock(expectation))
		// some random string
		Service.wallet.importKey("fail",
								 passcode: PASSCODE, keyBlock(expectation))
		wait(for: [expectation], timeout: 3)
	}

	// MARK: - Lock

	func testUnlockSuccess() {
		let expectation = XCTestExpectation()
		expectation.expectationDescription = "account should unlock"
		Service.wallet.importKey(PRIVATE_KEY,
								 passcode: PASSCODE) { account in
									guard let account = account else {
										return XCTFail("this key should be imported correctly")
									}
									try? account.timedUnlock(passcode: PASSCODE, timeout: 0.3)
									if !account.isLocked() {
										expectation.fulfill()
									}
		}
		wait(for: [expectation], timeout: 3)
	}

	func testUnlockFailure() {
		let expectation = XCTestExpectation()
		expectation.expectationDescription = "account should not unlock with an incorrect passcode"
		Service.wallet.importKey(PRIVATE_KEY,
								 passcode: PASSCODE) { account in
									guard let account = account else {
										return XCTFail("this key should be imported correctly")
									}
									try? account.timedUnlock(passcode: "098765", timeout: 0.3)
									if account.isLocked() {
										expectation.fulfill()
									}
		}
		wait(for: [expectation], timeout: 3)
	}
}
