//
//  CommentQ.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

indirect enum CommentSource {

	case update(Update)

	case campaign(Campaign)

	case comment(CommentSource, Comment)
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
