//
//  Campaign.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct PartialCampaign: Equatable, Codable {

	let id: String

	let name: String

	let description: String

	let image: String
}

struct Campaign: Equatable, Codable {

	let id:String

	let name:String

	let description:String

	let image:String

	let lastUpdate:Update?

	let lastComments:[Comment]
}
