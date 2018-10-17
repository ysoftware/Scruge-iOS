//
//  StringTruncate.swift
//  Scruge
//
//  Created by ysoftware on 17/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

extension String {
	/*
	Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
	- Parameter length: Desired maximum lengths of a string
	- Parameter trailing: A 'String' that will be appended after the truncation.

	- Returns: 'String' object.
	*/
	func truncate(to length: Int, trailing: String = " …") -> String {
		return (self.count > length) ? self.prefix(length) + trailing : self
	}
}
