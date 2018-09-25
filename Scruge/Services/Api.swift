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
		var params:[String:Any] = [:]
		// create params from query
		service.get("campaigns", params, completion)
	}

	// MARK: - Updates

	func getUpdateList(forCampaignId id:String,
					   completion: @escaping (Result<UpdateListResponse, NetworkingError>)->Void) {
		var params:[String:Any] = [:]
		params["id"] = id
		service.get("updates", params, completion)
	}
}
