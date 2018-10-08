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
//		= Network()) {
		= Mock()) {
		self.service = service
	}

	// MARK: - Auth

	func logIn(email:String,
			   password:String,
			   _ completion: @escaping (Result<LoginResponse, AnyError>)->Void) {
		let request = AuthRequest(login: email, password: password)
		service.post("auth/login", request.toDictionary(), completion)
	}

	func signUp(email:String,
				password:String,
				_ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		let request = AuthRequest(login: email, password: password)
		service.post("auth/register", request.toDictionary(), completion)
	}

	func checkEmail(_ email:String,
					_ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		let request = EmailRequest(email: email)
		service.post("auth/check_email", request.toDictionary(), completion)
	}

	// MARK: - Profile

	func updateProfileImage(_ image:UIImage,
							_ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		guard let data = image.jpegData(compressionQuality: 0.8) else {
			return completion(.failure(AnyError(NetworkingError.parsingError)))
		}
		service.upload("profile/image",
					   data: data,
					   fileName: "avatar.jpg",
					   mimeType: "image/jpeg", completion)
	}

	func updateProfile(name:String,
					   country:String,
					   description:String,
					   _ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		let request = ProfileRequest(name: name, country: country, description: description)
		service.post("profile", request.toDictionary(), completion)
	}

	func getProfile(_ completion: @escaping (Result<ProfileResponse, AnyError>)->Void) {
		service.post("profile", TokenRequest().toDictionary(), completion)
	}

	// MARK: - Categories

	func getCategories(_ completion: @escaping (Result<CategoriesResponse, AnyError>)->Void) {
		service.get("categories", TokenRequest().toDictionary(), completion)
	}

	// MARK: - Campaigns

	func getCampaign(with id:String,
					 _ completion: @escaping (Result<CampaignResponse, AnyError>)->Void) {
		service.get("campaign/\(id)", TokenRequest().toDictionary(), completion)
	}

	func getCampaignList(for query:CampaignQuery?,
						 _ completion: @escaping (Result<CampaignListResponse, AnyError>)->Void) {
		if let query = query, query.requestType != .regular {
			switch query.requestType {
			case .backed:
				return service.get("campaigns/backed", TokenRequest().toDictionary(), completion)
			case .subscribed:
				return service.get("campaigns/subscribed", TokenRequest().toDictionary(), completion)
			default: break
			}
		}
		let request = CampaignListRequest(from: query)
		service.get("campaigns", request.toDictionary(), completion)
	}

	// MARK: - Updates

	func getUpdateList(for campaign:Campaign,
					   _ completion: @escaping (Result<UpdateListResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/updates", TokenRequest().toDictionary(), completion)
	}

	// MARK: - HTML Description

	func getUpdateDescription(for update:Update,
							  in campaign:Campaign,
							  _ completion: @escaping (Result<HTMLResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/update/\(update.id)/description",
			TokenRequest().toDictionary(),
			completion)
	}

	func getCampaignDescription(for campaign:Campaign,
								_ completion: @escaping (Result<HTMLResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/description", TokenRequest().toDictionary(), completion)
	}

	// MARK: - Milestones

	func getMilestones(for campaign:Campaign,
					   _ completion: @escaping (Result<MilestoneListResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/milestones", TokenRequest().toDictionary(), completion)
	}

	// MARK: - Comments

	func postComment(_ comment:String,
					 source: CommentSource,
					 _ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		let method:String
		switch source {
		case .campaign(let campaign):
			method = "campaign/\(campaign.id)/comment"
		case .update(let campaign, let update):
			method = "campaign/\(campaign.id)/update/\(update.id)/comment"
		}
		let request = CommentRequest(comment: comment)
		service.post(method, request.toDictionary(), completion)
	}

	func getComments(for query:CommentQuery,
					 _ completion: @escaping (Result<CommentListResponse, AnyError>)->Void) {
		let method:String
		switch query.source {
		case .campaign(let campaign):
			method = "campaign/\(campaign.id)/comments"
		case .update(let campaign, let update):
			method = "campaign/\(campaign.id)/update/\(update.id)/comments"
		}
		let request = CommentListRequest(from: query)
		service.get(method, request.toDictionary(), completion)
	}
}
