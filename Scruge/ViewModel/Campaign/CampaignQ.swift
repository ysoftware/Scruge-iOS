//
//  CampaignQuery.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

struct CampaignQuery: Query {

	// MARK: - Pagination

	var currentPosition = 0

	mutating func advance() {
		currentPosition += 1
	}

	mutating func resetPosition() {
		currentPosition = 0
	}

	// MARK: - Request

	var category:CategoryVM?
}
