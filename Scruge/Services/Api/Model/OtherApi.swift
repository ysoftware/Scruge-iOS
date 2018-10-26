//
//  CategoryApi.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Request

struct SubscriptionResponse: Codable {

	let subscribed:Bool
}

struct ResultResponse: Codable {

	let result:Int
}

struct AccountRequest: Codable {

	let accountName:String

	let publicKey:String
}

// MARK: - Response

struct CategoriesResponse: Codable {

	let result:Int

	let data:[Category]
}

struct TagsResponse: Codable {

	let result:Int

	let tags:[String]
}

struct HTMLResponse: Codable {

	let result:Int

	let content:String
}
