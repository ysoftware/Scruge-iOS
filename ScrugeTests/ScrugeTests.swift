//
//  ScrugeTests.swift
//  ScrugeTests
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest
@testable import Scruge

final class WalletTests: XCTestCase {

	let PASSCODE = "123456"

	func importKeyBlock(_ expectation:XCTestExpectation) -> (SELocalAccount?)->Void {
		return { account in
			if account != nil {
				expectation.fulfill()
			}
		}
	}

	func testSuccessImport() {
		let expectation = XCTestExpectation()
		// correct private key created by keosd
		Service.wallet.importKey("5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3",
								 passcode: PASSCODE, importKeyBlock(expectation))
		wait(for: [expectation], timeout: 0.1)
	}

	func testFailImport() {
		let expectation = XCTestExpectation()
		expectation.isInverted = true

		// public key instead of private key
		Service.wallet.importKey("EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV",
								 passcode: PASSCODE, importKeyBlock(expectation))
		// modified private key
		Service.wallet.importKey("5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD2",
								 passcode: PASSCODE, importKeyBlock(expectation))
		// some random string
		Service.wallet.importKey("fail",
								 passcode: PASSCODE, importKeyBlock(expectation))
		wait(for: [expectation], timeout: 0.1)
	}
}
