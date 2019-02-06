//
//  Vote.swift
//  Scruge
//
//  Created by ysoftware on 30/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct VoteResult: Codable {

	let voteId:Int

	let active:Bool

	let positiveVotes:Int

	let backersCount:Int

	let voters:Int

	let kind:VoteKind

	let endTimestamp:Int64
}

struct Voting: Codable {

	let campaign:CampaignInfo

	let voting:VoteInfo
}

struct VoteInfo: Codable {

	let kind:VoteKind

	let voteId:Int

	let endTimestamp:Int64
}

enum VoteKind:Int, Codable {

	case extend = 0, milestone = 1
}
