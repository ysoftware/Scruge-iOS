//
//  Category.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Category: Equatable, Codable {

	let id:String

	let name:String
}

struct Social: Equatable, Codable {

	let twitter:String?

	let facebook:String?

	let instagram:String?

	let website:String?

	let vk:String?

	let youtube:String?
}

struct Faq: Equatable, Codable {

	let question:String

	let answer:String
}

struct Document: Equatable, Codable {

	let name:String

	let documentUrl:String
}
