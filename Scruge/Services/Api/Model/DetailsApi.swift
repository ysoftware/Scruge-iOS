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

	let activity:[ActivityHolder]
}

struct ActivityListRequest:Codable {

	let page:Int 
}
