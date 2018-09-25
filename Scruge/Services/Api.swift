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
					 _ completion: @escaping (Result<Campaign, AnyError>)->Void) {
		service.get("campaign", ["id":id]) { response in
			switch response {
			case .success(let json):
				// parse json
				completion(.success(Campaign(name: "")))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}

	func getCampaignList(for query:CampaignQuery?,
						 completion: @escaping (Result<[Campaign], AnyError>)->Void) {
		// create params from query
		let params:[String:Any] = [:]
		service.get("campaigns", params) { response in
			switch response {
			case .success(let json):
				// parse json
				completion(.success([]))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
