//
//  CampaignQuery.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

struct CampaignQuery: Query {

	var currentPosition = 0

	mutating func advance() {
		currentPosition += 1
	}

	func resetPosition() {

	}
}
