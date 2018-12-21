//
//  DataFormatting.swift
//  ScrugeTests
//
//  Created by ysoftware on 20/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import XCTest
@testable import Scruge

final class DataFormattingTests: XCTestCase {

	func testNumberString() {
		let sym = Locale.current.decimalSeparator!

		// formatRounding(to:min:)
		XCTAssertEqual("1\(sym)0000", 1.0.formatRounding(to: 10, min: 4))
		XCTAssertEqual("1\(sym)000001", 1.000001.formatRounding(to: 10, min: 4))

		// format(as:)
		XCTAssertEqual("1", 1.0.formatDecimal())
		XCTAssertEqual("1\(sym)1", 1.1.formatDecimal())
		XCTAssertEqual("1\(sym)01", 1.0100.formatDecimal())
	}

	func testDateMilliseconds() {
		let date = Date()
		let milliseconds = date.milliseconds
		XCTAssertEqual(Date(milliseconds: milliseconds).timeIntervalSince1970,
					   date.timeIntervalSince1970,
					   accuracy: 0.001)
	}

	func testEmailValidation() {
		// this is not a perfect list, but it's good enough

		let validEmails = """
		email@example.com
		firstname.lastname@example.com
		email@subdomain.example.com
		firstname+lastname@example.com
		email@123.123.123.123
		email@[123.123.123.123]
		1234567890@example.com
		email@example-one.com
		_______@example.com
		email@example.name
		email@example.museum
		email@example.co.jp
		firstname-lastname@example.com
""".components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespaces) }

		var failedValid = 0
		validEmails.forEach {
			if !$0.isValidEmail() {
				print("Should be valid: \($0)")
				failedValid += 1
			}
		}

		print("valid emails \(validEmails.count - failedValid)/\(validEmails.count)")

		let invalidEmails = """
		tiny
		plainaddress
		#@%^%#$@#$@#.com
		@example.com
		Joe Smith <email@example.com>
		email.example.com
		email@example@example.com
		.email@example.com
		email.@example.com
		email..email@example.com
		あいうえお@example.com
		email@example.com (Joe Smith)
		email@example
		email@-example.com
		email@example..com
		Abc..123@example.com
""".components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespaces) }

		var failedInvalid = 0
		invalidEmails.forEach {
			if $0.isValidEmail() {
				print("Should be invalid: \($0)")
				failedInvalid += 1
			}
		}
		print("invalid emails \(invalidEmails.count - failedInvalid)/\(invalidEmails.count)")

		XCTAssertEqual(0, failedInvalid + failedValid, "Email validation test have failed")
	}
}
