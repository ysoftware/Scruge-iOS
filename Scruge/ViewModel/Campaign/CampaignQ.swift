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

	var page = 0

	mutating func advance() {
		page += 1
	}

	mutating func resetPosition() {
		page = 0
	}

	// MARK: - Request

	enum RequestType {

		case regular, backed, subscribed
	}

	var requestType:RequestType = .regular

	var category:CategoryVM?

	var query:String?

	var tags:[String]?

	var type:String?
}
