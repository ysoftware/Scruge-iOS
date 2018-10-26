//
//  Campaign.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct CampaignInfo: Equatable, Codable {

	let id:String

	let title:String

	let imageUrl:String
}

struct PartialCampaign: Equatable, Codable, PartialCampaignModel {

	let id:String

	let title:String

	let description:String

	let imageUrl:String

	let startTimestamp:Int

	let endTimestamp:Int

	let hardCap:Double

	let softCap:Double

	let raised:Double
}

struct Campaign: Equatable, Codable, PartialCampaignModel {

	let id:String

	let title:String
	
	let description:String

	let imageUrl:String

	let startTimestamp:Int

	let endTimestamp:Int

	let hardCap:Double

	let softCap:Double

	let raised:Double

	// MARK: - Full campaign only

	var isSubscribed:Bool?

	let state:Int?

	let publicTokenPercent:Double

	let tokenSupply:Double?

	let annualInflationPercent:Range?

	let about:String?

	let videoUrl:String // video

	let totalCommentsCount:Int

	let	social:[Social]?

	let faq:[Faq]?

	let documents:[Document]?

//	let rewards:[Reward]?

	let currentMilestone:Milestone?

	let lastUpdate:Update?

	let topComments:[Comment]?
}

protocol PartialCampaignModel {

	var id:String { get }

	var title:String { get }

	var description:String { get }

	var imageUrl:String { get }

	var startTimestamp:Int { get }

	var endTimestamp:Int { get }

	var hardCap:Double { get }

	var softCap:Double { get }

	var raised:Double { get }
}
