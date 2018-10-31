//
//  Economics.swift
//  Scruge
//
//  Created by ysoftware on 26/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

#warning("убрать optional значения где они не нужны")

struct Economics: Equatable, Codable {

	let hardCap:Double

	let softCap:Double

	let raised:Double

	let publicTokenPercent:Double?

	let tokenSupply:Double?

	let annualInflationPercent:Range?

	let minUserContribution:Double?

	let maxUserContribution:Double?
}
