//
//  Balance.swift
//  Scruge
//
//  Created by ysoftware on 23/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Balance {

	let symbol:String

	let amount:NSDecimalNumber
}

extension Balance: Comparable {

	static func < (lhs: Balance, rhs: Balance) -> Bool {
		return lhs.symbol < rhs.symbol
	}
}
