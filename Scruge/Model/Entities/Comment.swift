//
//  Comment.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Comment:Equatable, Codable {

	let id:String

	let text:String

	let timestamp:Int

	let authorName:String?

	let authorAvatar:String?

	var likeCount:Int
	
	let repliesCount:Int?

	var isLiking:Bool?
}
