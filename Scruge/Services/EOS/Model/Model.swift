//
//  Model.swift
//  Scruge
//
//  Created by ysoftware on 16/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

//	vote
//		name eosAccount
//		uint64_t userId
//		uint64_t campaignId
//		bool vote

struct Vote:Codable {

	let eosAccount:String

	let userId:Int

	let campaignId:Int

	let vote:Bool
}

//	delegatebw
// 		account_name from
//		account_name receiver
//		asset stake_net_quantity
//		asset stake_cpu_quantity
//		bool transfer

struct DelegateBW:Codable {

	let from:String

	let receiver:String

	let stake_cpu_quantity:String

	let stake_net_quantity:String

	let transfer:Bool
}

//	undelegatebw
//		account_name from
//		account_name receiver
//		asset unstake_net_quantity
//		asset unstake_cpu_quantity

struct UndelegateBW:Codable {

	let from:String

	let receiver:String

	let unstake_cpu_quantity:String

	let unstake_net_quantity:String
}
