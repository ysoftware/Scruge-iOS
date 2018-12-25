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

	func testExchangeRates() {
		let er = Service.exchangeRates

		let eos = 2.5030
		let rub = 0.01499
		let eur = 1.1387
		let scr = 0.029

		er.setupForTesting(rates: [.eos: eos, .rub: rub, .eur: eur, .scr: scr])

		let SCR_RUB = er.convert(Quantity(1, .scr), to: .rub)?.amount ?? 0
		XCTAssertEqual(scr/rub, SCR_RUB, accuracy: 0.00001)

		let EOS_RUB = er.convert(Quantity(1, .eos), to: .rub)?.amount ?? 0
		XCTAssertEqual(eos/rub, EOS_RUB, accuracy: 0.00001)

		let USD_RUB = er.convert(Quantity(1, .usd), to: .rub)?.amount ?? 0
		XCTAssertEqual(1/rub, USD_RUB, accuracy: 0.00001)

		let RUB_EUR = er.convert(Quantity(1, .rub), to: .eur)?.amount ?? 0
		XCTAssertEqual(rub/eur, RUB_EUR, accuracy: 0.00001)

		let USD_SCR = er.convert(Quantity(1, .usd), to: .scr)?.amount ?? 0
		XCTAssertEqual(1/scr, USD_SCR, accuracy: 0.00001)
	}
}
