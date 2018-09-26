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
						 _ completion: @escaping (Result<CampaignListResponse, NetworkingError>)->Void) {
		let params:[String:Any] = [:]
		// create params from query
		service.get("campaigns", params, completion)
	}

	// MARK: - Updates

	func getUpdateList(for campaign:Campaign,
					   _ completion: @escaping (Result<UpdateListResponse, NetworkingError>)->Void) {
		var params:[String:Any] = [:]
		params["id"] = campaign.id
		service.get("updates", params, completion)
	}

	func getUpdateDescription(for update:Update,
							  _ completion: @escaping (Result<HTMLResponse, NetworkingError>)->Void) {
		service.get("update/\(update.id)/description", nil, completion)
	}

	// MARK: - Milestones

	func getMilestones(for campaign:Campaign,
					   _ completion: @escaping (Result<MilestoneListResponse, NetworkingError>)->Void) {
		service.get("campaign/\(campaign.id)/milestones", nil, completion)
	}

	// MARK: - Comments

	func getComments(for campaign:Campaign,
					 _ completion: @escaping (Result<CommentListResponse, NetworkingError>)->Void) {
		service.get("campaign/\(campaign.id)/comments", nil, completion)
	}

	func getComments(for update:Update,
					 _ completion: @escaping (Result<CommentListResponse, NetworkingError>)->Void) {
		service.get("update/\(update.id)/comments", nil, completion)
	}
}
