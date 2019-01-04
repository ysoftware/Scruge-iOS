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
		var parentCommentId:String?
		var campaignId:Int?
		var updateId:String?

		func setup(with source:CommentSource) {
			switch source {
			case .campaign(let campaign):
				campaignId = campaign.id
			case .update(let update):
				updateId = update.id
			case .comment(let innerSource, _):
				setup(with: innerSource)
			}
		}

		setup(with: source)
		if case .comment(_, let comment) = source {
			parentCommentId = comment.id
		}

		self.token = token
		self.parentCommentId = parentCommentId
		self.campaignId = campaignId
		self.updateId = updateId
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
		var campaignId:Int?
		var updateId:String?

		func setup(with source:CommentSource) {
			switch source {
			case .campaign(let campaign):
				campaignId = campaign.id
			case .update(let update):
				updateId = update.id
			case .comment(let innerSource, _):
				setup(with: innerSource)
			}
		}

		setup(with: query.source)
		if case .comment(_, let comment) = query.source {
			self.parentCommentId = comment.id
		}
		else {
			self.parentCommentId = nil
		}

		self.token = token
		self.campaignId = campaignId
		self.updateId = updateId
		self.page = query.page
	}
}
