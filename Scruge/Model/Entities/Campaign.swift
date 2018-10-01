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

	let imageUrl:String

	let endTimestamp:Int

	let raisedAmount:Double

	let fundAmount:Double
}

struct Campaign: Equatable, Codable {

	let id:String

	let title:String

	let description:String

	let mediaUrl:String // image or video

	let endTimestamp:Int

	let raisedAmount:Double

	let fundAmount:Double

	// MARK: - Full campaign only

	let totalCommentsCount:Int

	let rewards:[Reward]

	let currentMilestone:Milestone

	let lastUpdate:Update?

	let lastComments:[Comment]
}
