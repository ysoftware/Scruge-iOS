//
//  UIExtensions.swift
//  ScrugeUITests
//
//  Created by ysoftware on 05/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import XCTest

extension XCUIElement {

	/**
	Removes any current text in the field before typing in the new value
	- Parameter text: the text to enter into the field
	*/
	func clearAndEnterText(text: String) {
		guard let stringValue = self.value as? String else { return }
		let string = stringValue.map { _ in XCUIKeyboardKey.delete.rawValue }.joined(separator: "") + text
		typeText(string)
	}
}
