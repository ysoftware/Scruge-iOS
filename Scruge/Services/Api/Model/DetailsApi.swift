//
//  DetailsApi.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct MilestoneListResponse: Codable {

	let milestones:[Milestone]
}

struct UpdateListResponse: Codable {

	let updates:[Update]
}

struct ActivityListResponse:Codable {

	let updates:[ActivityModel]

	init(from decoder: Decoder) throws {
		updates = []
		// TO-DO: parse object
	}

	func encode(to encoder: Encoder) throws {

	}
}
