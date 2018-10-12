//
//  Reward.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Reward: Equatable, Codable {

	let id:String

	let amount:Int

	let title:String

	let description:String

	let available:Int?

	let totalAvailable:Int?
}
