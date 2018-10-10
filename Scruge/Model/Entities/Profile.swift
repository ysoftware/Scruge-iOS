//
//  User.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Profile: Equatable, Codable {

	let login:String?

	let name:String?

	let country:String?

	let imageUrl:String?

	let description:String?
}
