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

	let comments:[Comment]
}

// MARK: - Request

struct CommentLikeRequest:Codable {

	let token:String

	let value:Bool
}

struct CommentRequest: Codable {

	let text:String

	let parentCommentId:String?

	let token:String
}

struct CommentListRequest: Codable {

	let page:Int?

	let parentId:String?

	let token:String?
}
