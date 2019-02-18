//
//  BountyApi.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Request

struct ProjectsRequest:Codable {

	let page:Int
}

struct BountiesRequest:Codable {

	let providerName:String
}

struct SubmissionRequest:Codable {

	let token:String

	let bountyId:Int64

	let proof:String

	let hunterName:String

	let providerName:String
}

// MARK: - Response

struct ProjectsResponse:Codable {

	let projects: [Project]
}

struct BountiesResponse:Codable {

	let bounties: [Bounty]
}
