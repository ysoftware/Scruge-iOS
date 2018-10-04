//
//  CommentQ.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

enum CommentSource {

	case update(Campaign, Update)

	case campaign(Campaign)
}

struct CommentQuery: Query {

	let source:CommentSource

	var page = 0

	mutating func advance() {
		page += 1
	}

	mutating func resetPosition() {
		page = 0
	}
}
