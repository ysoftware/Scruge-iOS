//
//  ProjectQ.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM

struct ProjectQ:Query {

	// MARK: - Pagination

	var page = 0

	mutating func advance() {
		page += 1
	}

	mutating func resetPosition() {
		page = 0
	}
}
