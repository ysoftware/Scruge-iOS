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

struct ActivityHolder:Equatable, Codable {

	init(activity:ActivityModel) { // debug purposes only
		self.activity = activity
	}

	let activity:ActivityModel

	// TO-DO: if needed, this should be changed
	static func == (lhs: ActivityHolder, rhs: ActivityHolder) -> Bool {
		return lhs.activity.type == rhs.activity.type
	}

	// Custom parsing

	enum Keys:CodingKey { case type }

	init(from decoder: Decoder) throws {
		// TO-DO: parse object

		let object = try decoder.container(keyedBy: Keys.self)
		let type = try object.decode(String.self, forKey: .type)

		switch type {
		case "Reply": activity = try ActivityReply(from: decoder)
		case "Update": activity = try ActivityUpdate(from: decoder)
		case "CampFundingEnd": activity = try ActivityFunding(from: decoder)
		case "Voting": activity = try ActivityVoting(from: decoder)
		case "VotingResult": activity = try ActivityVotingResult(from: decoder)
		default: throw BackendError.parsingError
		}
	}

	func encode(to encoder: Encoder) throws {

	}
}

struct ActivityUpdate: ActivityModel, Equatable, Codable {

	let type:String // Update

	let update:Update

	let campaign:CampaignInfo
}

struct ActivityReply: ActivityModel, Equatable, Codable {

	let type:String // Reply

	let replyCommentText:String

	let parentCommentId:String

	let replyUserName:String

	let timestamp:Int
}

struct ActivityVoting: ActivityModel, Equatable, Codable {

	let type:String // Voting

	let campaign:CampaignInfo

	let milestoneTitle:String

	let startTimestamp:Int

	let kind:Int

	let timestamp:Int

	let noticePeriodSec:Int // TO-DO: Это значения в секундах 7 дней (7*24*60*60), 3 дня или 0
}

struct ActivityVotingResult: ActivityModel, Equatable, Codable {

	let type:String // Voting

	let campaign:CampaignInfo

	let milestoneTitle:String

	let startTimestamp:Int

	let endTimestamp:Int

	let kind:Int

	let timestamp:Int
}

struct ActivityFunding: ActivityModel, Equatable, Codable {

	let type:String // CampFundingEnd

	let campaign:CampaignInfo

	let softCap:Double

	let raised:Double

	let timestamp:Int
}
