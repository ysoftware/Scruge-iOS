//
//  Activity.swift
//  Scruge
//
//  Created by ysoftware on 16/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation

protocol ActivityModel:Codable {

	var type:String { get }
}

struct ActivityHolder:Equatable {

	let activity:ActivityModel

	// TO-DO: if needed, this should be changed
	static func == (lhs: ActivityHolder, rhs: ActivityHolder) -> Bool {
		return lhs.activity.type == rhs.activity.type
	}
}

struct ActivityUpdate: ActivityModel, Equatable, Codable {

	let type:String

	let update:Update

	let campaign:CampaignInfo
}

struct ActivityReply: ActivityModel, Equatable, Codable {

	let type:String

	let replyId:String

	let campaignId:String

	let replyCommentText:String

	let replyUserName:String
}

struct ActivityVoting: ActivityModel, Equatable, Codable {

	let type:String

	let campaign:CampaignInfo

	let milestoneTitle:String

	let timestamp:Int
}

struct ActivityFunding: ActivityModel, Equatable, Codable {

	let type:String


}
