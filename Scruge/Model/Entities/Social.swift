//
//  Social.swift
//  Scruge
//
//  Created by ysoftware on 11/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

enum SocialNetwork:String, Codable {

	case facebook = "facebook"

	case twitter = "twitter"

	case website = "website"

	case vk = "vk"

	case instagram = "instagram"

	case youtube = "youtube"

	case telegram = "telegram"

	case slack = "slack"

	case linkedIn = "linkedIn"

	case medium = "medium"
}

struct Social:Codable, Equatable {

	let url:String

	let name:String
}
