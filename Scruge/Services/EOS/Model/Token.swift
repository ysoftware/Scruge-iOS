//
//  Token.swift
//  Scruge
//
//  Created by ysoftware on 18/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation

struct Token:Equatable, Hashable {

	let contract:EosName

	let symbol:String

	init(contract:EosName, symbol:String) {
		self.contract = contract
		self.symbol = symbol
	}

	init?(string:String) {
		let array = string.components(separatedBy: " ")
		guard array.count == 2, let contract = EosName(from: array[0]) else { return nil }
		self.contract = contract
		self.symbol = array[1]
	}

	static let EOS = Token(contract: EosName.create("eosio.token"), symbol: "EOS")

	static let SYS = Token(contract: EosName.create("eosio.token"), symbol: "SYS")

	static let Scruge = Token(contract: EosName.create("eosio.token"), symbol: "SCR")

	static let `default` = [EOS, Scruge]
}
