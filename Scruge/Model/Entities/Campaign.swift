//
//  Campaign.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct CampaignInfo: Equatable, Codable {

	let id:Int

	let title:String

	let imageUrl:String
}

struct PartialCampaign: Equatable, Codable, PartialCampaignModel {

	let id:Int

	let title:String

	let description:String

	let imageUrl:String

	let startTimestamp:Int

	let endTimestamp:Int

	let economics: Economics
}

struct Campaign: Equatable, Codable, PartialCampaignModel {

	let id:Int

	let title:String
	
	let description:String

	let imageUrl:String

	let startTimestamp:Int

	let endTimestamp:Int

	let economics: Economics

	// MARK: - Full campaign only

	let team:[Member]

	let status:Int

	let about:String?

	let videoUrl:String // video

	let totalCommentsCount:Int

	let	social:[Social]?

	let faq:[Faq]?

	let documents:[Document]?

	let currentMilestone:Milestone?

	let lastUpdate:Update?

	let topComments:[Comment]?

	let pitchUrl:String?
}

protocol PartialCampaignModel {

	var id:Int { get }

	var title:String { get }

	var description:String { get }

	var imageUrl:String { get }

	var startTimestamp:Int { get }

	var endTimestamp:Int { get }

	var economics:Economics { get }
}
