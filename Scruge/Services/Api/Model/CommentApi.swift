//
//  CommentApi.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Response

struct CommentListResponse: Codable {

	let result:Int

	let data:[Comment]
}

// MARK: - Request

struct CommentRequest: Codable {

	init(comment:String) {
		self.comment = comment
	}

	let comment:String

	let token = Service.tokenManager.getToken()
}

struct CommentListRequest: Codable {

	init(from q: CommentQuery?) {
		page = q?.page ?? 0
	}

	let page:Int
}
