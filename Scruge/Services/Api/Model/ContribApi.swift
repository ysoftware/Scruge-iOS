//
//  ContribApi.swift
//  Scruge
//
//  Created by ysoftware on 31/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Request

struct ContributionNotificationRequest: Codable {

	let amount:Double

	let campaignId:Int

	let transactionId:String
}

struct VoteNotificationRequest: Codable {

	let value:Bool

	let campaignId:Int

	let transactionId:String
}

// MARK: - Response

struct ContributionHistoryResponse: Codable {

	let contributions:[Contribution]
}
