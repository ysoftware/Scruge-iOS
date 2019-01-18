//
//  Balance.swift
//  Scruge
//
//  Created by ysoftware on 23/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Balance {

	let token:Token

	let amount:Double

	init(token:Token, amount:Double) {
		self.token = token
		self.amount = amount
	}

	init?(balance:String, contract:EosName) {
		let array = balance.components(separatedBy: " ")
		if array.count == 2, let amount = Double(array[0]) {
			self.token = Token(contract: contract, symbol: array[1])
			self.amount = amount
		}
		return nil
	}
}

extension Balance: Comparable {

	static func < (lhs: Balance, rhs: Balance) -> Bool {
		return lhs.amount < rhs.amount
	}
}
