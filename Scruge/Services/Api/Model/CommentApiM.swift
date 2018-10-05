//
//  CommentResp.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Response

struct CommentListResponse: Codable {

	let data:[Comment]
}

// MARK: - Request

struct CommentListRequest: Codable {

	init(from q: CommentQuery?) {
		page = q?.page ?? 0
	}

	let page:Int

	let token = Service.tokenManager.getToken()
}
