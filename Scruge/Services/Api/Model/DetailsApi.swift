//
//  DetailsApi.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct MilestoneListResponse: Codable {

	let result:Int

	let milestones:[Milestone]
}

struct UpdateListResponse: Codable {

	let result:Int

	let updates:[Update]
}

struct ActivityListResponse: Codable {

	let result:Int

	let updates:[Activity]
}
