//
//  Balance.swift
//  Scruge
//
//  Created by ysoftware on 23/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Balance:Equatable, Hashable, CustomStringConvertible {

	var description: String { return string }

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

	var string:String {
		let amount = self.amount.formatRounding(to: 4, min: 4).replacingOccurrences(of: ",", with: ".")
		return "\(amount) \(token.symbol)"
	}

	static func ==(lhs:Balance, rhs:Balance) -> Bool {
		return lhs.token == rhs.token
	}
}

extension Balance: Comparable {

	static func < (lhs: Balance, rhs: Balance) -> Bool {
		return lhs.amount < rhs.amount
	}
}
