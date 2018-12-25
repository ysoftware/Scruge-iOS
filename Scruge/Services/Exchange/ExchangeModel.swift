//
//  Model.swift
//  
//
//  Created by ysoftware on 25/12/2018.
//

import Foundation

enum Asset:String, Codable {

	case usd = "USD", scr = "SCR", eos = "EOS", eur = "EUR", rub = "RUB"
}

struct Quantity {

	let amount:Double

	let asset:Asset

	init(_ amount:Double, _ asset: Asset) {
		self.amount = amount
		self.asset = asset
	}
}
