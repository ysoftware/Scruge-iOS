//
//  Project.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation

struct Exchange: Codable, Equatable {

	let name:String

	let url:String
}

struct ProjectEconomics: Codable, Equatable {

	let tokenSupply:Int

	let annualInflationPercent:Range

	let listingTimestamp:Int64?

	let exchange:Exchange?
}

struct Project: Codable, Equatable {

	let providerName:String

	let projectName:String

	let projectDescription:String

	let videoUrl:String

	let social:[Social]

	let documents:[Document]

	let economics:ProjectEconomics
}
