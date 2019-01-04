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

	let parentCommentId:String?

	let campaignId:Int?

	let updateId:String?

	let token:String

	let text:String

	init(from source:CommentSource, token:String, text:String) {
		if case .campaign(let campaign) = source { campaignId = campaign.id }
		else { campaignId = nil }
		if case .update(let update) = source { updateId = update.id }
		else { updateId = nil }
		if case .comment(_, let comment) = source { parentCommentId = comment.id }
		else { parentCommentId = nil }

		self.token = token
		self.text = text
	}
}

struct CommentListRequest: Codable {

	let parentCommentId:String?

	let campaignId:Int?

	let updateId:String?

	let page:Int?

	let token:String?

	init(from query:CommentQuery, token:String?) {
		if case .campaign(let campaign) = query.source { campaignId = campaign.id }
		else { campaignId = nil }
		if case .update(let update) = query.source { updateId = update.id }
		else { updateId = nil }
		if case .comment(_, let comment) = query.source { parentCommentId = comment.id }
		else { parentCommentId = nil }

		self.token = token
		self.page = query.page
	}
}
