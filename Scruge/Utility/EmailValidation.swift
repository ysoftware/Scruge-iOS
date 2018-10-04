//
//  EmailValidation.swift
//  Scruge
//
//  Created by ysoftware on 04/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

extension String {

	func isValidEmail() -> Bool {
		let firstPart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
		let secondPart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
		let emailRegex = firstPart + "@" + secondPart + "[A-Za-z]{2,8}"
		let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
		return emailPredicate.evaluate(with: self)
	}
}
