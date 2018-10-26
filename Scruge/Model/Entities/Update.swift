//
//  Update.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Update: Equatable, Codable {

	let id:String

	let title:String

	let timestamp:Int

	let description:String?

	let imageUrl:String?

	var campaignInfo:CampaignInfo?
}

struct Activity: Equatable, Codable {

	let update:Update

	let campaign:CampaignInfo
}
