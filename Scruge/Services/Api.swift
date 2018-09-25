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

	init(service:Networking = Network(baseUrl: "http://api.scruge.com/v1/")) {
		self.service = service
	}

	// MARK: - Campaigns

	func getCampaign(with id:String,
					 _ completion: @escaping (Result<CampaignResponse, NetworkingError>)->Void) {
		service.get("campaign", ["id":id], completion)
	}

	func getCampaignList(for query:CampaignQuery?,
						 completion: @escaping (Result<CampaignListResponse, NetworkingError>)->Void) {
		// create params from query
		let params:[String:Any] = [:]
		service.get("campaigns", params, completion)
	}

	// MARK: - Comments


}
