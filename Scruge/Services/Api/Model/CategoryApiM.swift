//
//  CategoryApiM.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct CategoriesResponse: Codable {

	let result:Int

	let data:[Category]
}

struct TagsResponse: Codable {

	let result:Int

	let data:[String]
}
