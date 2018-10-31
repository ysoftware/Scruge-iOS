//
//  Member.swift
//  Scruge
//
//  Created by ysoftware on 31/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Member: Equatable, Codable {

	let name:String

	let description:String

	let position:String

	let imageUrl:String

	let social:[Social]
}
