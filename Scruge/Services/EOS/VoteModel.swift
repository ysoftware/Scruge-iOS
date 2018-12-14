//
//  Model.swift
//  Scruge
//
//  Created by ysoftware on 16/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Vote:Codable {

	let eosAccount:String

	let userId:Int

	let campaignId:Int

	let vote:Bool
}
