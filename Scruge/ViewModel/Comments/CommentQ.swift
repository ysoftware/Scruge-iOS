//
//  CommentQ.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

enum CommentSource {

	case update(Update)

	case campaign(Campaign)
}

struct CommentQuery: Query {

	var currentPosition = 0

	mutating func advance() {
		currentPosition += 1
	}

	mutating func resetPosition() {
		currentPosition = 0
	}
}
