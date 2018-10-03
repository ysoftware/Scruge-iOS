//
//  Campaign.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct PartialCampaign: Equatable, Codable, PartialCampaignModel {

	let id:String

	let title:String

	let type:String

	let description:String

	let imageUrl:String

	let endTimestamp:Int

	let raisedAmount:Double

	let fundAmount:Double
}

struct Campaign: Equatable, Codable, PartialCampaignModel {

	let id:String

	let title:String

	let type:String
	
	let description:String

	let endTimestamp:Int

	let raisedAmount:Double

	let imageUrl:String

	let fundAmount:Double

	// MARK: - Full campaign only

	let mediaUrl:String // image or video

	let totalCommentsCount:Int

	let rewards:[Reward]

	let currentMilestone:Milestone?

	let lastUpdate:Update?

	let topComments:[Comment]
}

protocol PartialCampaignModel {

	var id:String { get }

	var title:String { get }

	var description:String { get }

	var imageUrl:String { get }

	var endTimestamp:Int { get }

	var raisedAmount:Double { get }

	var fundAmount:Double { get }
}
