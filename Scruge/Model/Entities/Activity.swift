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
		default: throw BackendError.parsingError
		}
	}

	func encode(to encoder: Encoder) throws {

	}
}

struct ActivityUpdate: ActivityModel, Equatable, Codable {

	let type:String

	let update:Update

	let campaign:CampaignInfo
}

struct ActivityReply: ActivityModel, Equatable, Codable {

	let type:String

	let replyCommentText:String

	let replyUserName:String

	let timestamp:Int
}

struct ActivityVoting: ActivityModel, Equatable, Codable {

	let type:String

	let campaign:CampaignInfo

	let milestoneTitle:String

//	let timestamp:Int

	let kind:Int
}

struct ActivityFunding: ActivityModel, Equatable, Codable {

	let type:String


}
