//
//  Model.swift
//  Scruge
//
//  Created by ysoftware on 16/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// rammarket table
struct RamMarket: Codable {

	struct Value: Codable {
		
		let balance:String

		let weight:ActionSeq
	}

	let supply:String

	let base:Value

	let quote:Value
}

// buyrambytes
//		name payer
//		name receiver
//		uint32_t bytes

struct BuyRamBytes:Codable {

	let payer:String

	let receiver:String

	let bytes:Int64
}

// buyram
//		name payer
//		name receiver
//		asset quant

struct BuyRam:Codable {

	let payer:String

	let receiver:String

	let quant:String
}


// sellram
//		name account
//		int64_t bytes

struct SellRam:Codable {

	let account:String

	let bytes:Int64
}

// submit
//		name hunterName
//		name providerName
//		string proof
//		uint64_t bountyId

struct Submission:Codable {

	let hunterName:String

	let providerName:String

	let proof:String

	let bountyId:Int64
}

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

//	voteproducer
//		account_name voter_name
//		account_name proxy
//		vector<account_name> producers

struct VoteProducers:Codable {

	let voter:String

	let proxy:String

	let producers:[String]

	init(voter:String, proxy:String) {
		self.voter = voter
		self.proxy = proxy
		self.producers = []
	}

	init(voter:String, producers:[String]) {
		self.voter = voter
		self.producers = producers
		self.proxy = ""
	}
}
