//
//  Bounty.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation

struct Bounty: Codable, Equatable {

	let bountyName:String?

	let bountyId: Int64

	let providerName: String

	let bountyDescription: String

	let rewardsDescription: String

	let rulesDescription: String

	let limitPerUser: Int

	let timeLimit: Int64

	let userLimit: Int

	let budget: String

	let endTimestamp: Int64

	let paid: String

	let paidEOS: String

	let submissions: Int

	let participantsPaid: Int

	let timestamp: Int64

	let totalSupply:Int64? = 250000000

	let maxReward:String? = ["5000 SCR", "10000 SCR", "1000 SCR", "500 SCR", "2500 SCR"].randomElement()
}
