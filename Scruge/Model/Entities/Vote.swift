//
//  Vote.swift
//  Scruge
//
//  Created by ysoftware on 30/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct VoteResults: Codable {

	let voteId:Int

	let positiveVotes:Int

	let backersCount:Int

	let voters:Int

	let kind:VoteKind
}

enum VoteKind:Int, Codable {

	case extend = 0, milestone = 1
}
