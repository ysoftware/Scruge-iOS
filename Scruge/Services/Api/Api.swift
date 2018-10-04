//
//  API.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Result
import SwiftHTTP

struct Api {

	// MARK: - Initialization

	let service:Networking

	init(service:Networking
//		= Network(baseUrl: "https://scruge.com/api/")) {
		= Mock()) {
		self.service = service
	}

	// MARK: - Auth

	func logIn(email:String,
			   password:String,
			   _ completion: @escaping (Result<LoginResponse, AnyError>)->Void) {
		let request = AuthRequest(email: email, password: password)
		service.post("auth/login", request.toDictionary(), completion)
	}

	func signUp(email:String,
				password:String,
				_ completion: @escaping (Result<AuthResponse, AnyError>)->Void) {
		let request = AuthRequest(email: email, password: password)
		service.post("auth/register", request.toDictionary(), completion)
	}

	func checkEmail(_ email:String,
					_ completion: @escaping (Result<AuthResponse, AnyError>)->Void) {
		let request = EmailRequest(email: email)
		service.post("auth/check_email", request.toDictionary(), completion)
	}

	func getProfile(token:String,
					_ completion: @escaping (Result<ProfileResponse, AnyError>)->Void) {

	}

	// MARK: - Categories

	func getCategories(_ completion: @escaping (Result<CategoriesResponse, AnyError>)->Void) {
		service.get("categories", nil, completion)
	}

	// MARK: - Campaigns

	func getCampaign(with id:String,
					 _ completion: @escaping (Result<CampaignResponse, AnyError>)->Void) {
		service.get("campaign/\(id)", nil, completion)
	}

	func getCampaignList(for query:CampaignQuery?,
						 _ completion: @escaping (Result<CampaignListResponse, AnyError>)->Void) {
		let request = CampaignListRequest(from: query)
		service.get("campaigns", request.toDictionary(), completion)
	}

	// MARK: - Updates

	func getUpdateList(for campaign:Campaign,
					   _ completion: @escaping (Result<UpdateListResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/updates", nil, completion)
	}

	// MARK: - HTML Description

	func getUpdateDescription(for update:Update,
							  in campaign:Campaign,
							  _ completion: @escaping (Result<HTMLResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/update/\(update.id)/description", nil, completion)
	}

	func getCampaignDescription(for campaign:Campaign,
								_ completion: @escaping (Result<HTMLResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/description", nil, completion)
	}

	// MARK: - Milestones

	func getMilestones(for campaign:Campaign,
					   _ completion: @escaping (Result<MilestoneListResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/milestones", nil, completion)
	}

	// MARK: - Comments

	func getComments(for campaign:Campaign,
					 _ completion: @escaping (Result<CommentListResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/comments", nil, completion)
	}

	func getComments(for update:Update,
					 in campaign:Campaign,
					 _ completion: @escaping (Result<CommentListResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/update/\(update.id)/comments", nil, completion)
	}
}
