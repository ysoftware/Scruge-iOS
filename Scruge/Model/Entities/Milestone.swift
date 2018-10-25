//
//  Milestone.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Milestone: Equatable, Codable {

	let id:String

	let title:String

	let endTimestamp:Int

	let description:String

	let fundsReleasePercent:Double?
}
