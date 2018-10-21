//
//  Services.swift
//  ScrugeTests
//
//  Created by ysoftware on 21/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest
@testable import Scruge

final class ServicesTests: XCTestCase {

	func testTokenManager() {
		let token = String.random()

		Service.tokenManager.save(token)
		XCTAssertEqual(Service.tokenManager.getToken(), token)

		Service.tokenManager.removeToken()
		XCTAssertNil(Service.tokenManager.getToken())
	}
}
