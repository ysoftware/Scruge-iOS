//
//  API.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Result

struct Api {

	// MARK: - Initialization

	let service:Networking

	init(service:Networking = Network()) {
		self.service = service
	}

	// MARK: - Campaigns

	func getCampaign(completion: @escaping (Result<Campaign, AnyError>)->Void) {

	}

	func getCampaignList(completion: @escaping (Result<[Campaign], AnyError>)->Void) {
		
	}
}
