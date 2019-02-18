//
//  BreakLine.swift
//  Scruge
//
//  Created by ysoftware on 18/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation
import appendAttributedString

extension NSMutableAttributedString {

	@discardableResult
	func lineBreak() -> Self {
		return append("\n")
	}

	@discardableResult
	func whitespace() -> Self {
		return append(" ")
	}
}
