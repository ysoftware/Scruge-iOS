//
//  Campaign.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct PartialCampaign: Equatable, Codable {

	let id:String

	let title:String

	let description:String

	let image:String

	let endTimestamp:Int

	let raisedAmount:Int

	let fundAmount:Int
}

struct Campaign: Equatable, Codable {

	let id:String

	let title:String

	let description:String

	let image:String

	let endTimestamp:Int

	let raisedAmount:Int

	let fundAmount:Int

	// MARK: - Full campaign only

	let totalCommentsCount:Int

	let rewards:[Reward]

	let currentMilestone:Milestone

	let lastUpdate:Update?

	let lastComments:[Comment]
}
