//
//  API.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Result
import SwiftHTTP

final class Api {

	enum Environment:String {

		case test = "http://testapi.scruge.world/"

		case prod = "https://api.scruge.world/"

		case dev = "http://176.213.156.167/"
	}

	// MARK: - Initialization

	private(set) var service:Networking = Network(baseUrl: Environment.prod.rawValue)

	func setEnvironment(_ environment:Environment) {
		service = Network(baseUrl: environment.rawValue)
	}

	// MARK: - Wallet

	func createAccount(withName accountName: String,
					   publicKey: String,
					   _ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		let request = AccountRequest(name: accountName, publicKey: publicKey)
		service.post("user/\(token)/create_eos_account", request.toDictionary(), completion)
	}

	func getDefaultTokens(_ completion: @escaping (Result<[Token], AnyError>)->Void) {
		return completion(.success(["diatokencore DIA",       // arbitrary list of "top" tokens
			"eosblackteam BLACK",
			"taketooktook TOOK",
			"publytoken11 PUB",
			"everipediaiq IQ",
			"betdicetoken DICE",
			"zkstokensr4u ZKS",
			"hirevibeshvt HVT",
			"goldioioioio FGIO",
			"ethsidechain EETH"].compactMap { Token(string: $0) }))
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

	func getUserId(_ completion: @escaping (Result<UserIdResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		service.get("user/\(token)/id", nil, completion)
	}

	func updateProfileImage(_ image:UIImage,
							_ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		guard let data = image.jpegData(compressionQuality: 0.8) else {
			return completion(.failure(AnyError(BackendError.parsingError)))
		}
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		service.upload("avatar/\(token)",
					   nil,
					   data: data,
					   fileName: "image.jpg",
					   mimeType: "image/jpeg", completion)
	}

	func updateProfile(name:String,
					   country:String,
					   description:String,
					   _ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		let request = ProfileRequest(name: name, country: country, description: description)
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		service.put("profile/\(token)", request.toDictionary(), completion)
	}

	func getProfile(_ completion: @escaping (Result<ProfileResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		service.get("profile/\(token)", nil, completion)
	}

	// MARK: - Categories & Tags

	func getCategories(_ completion: @escaping (Result<CategoriesResponse, AnyError>)->Void) {
		service.get("categories", nil, completion)
	}

	func getTags(_ completion: @escaping (Result<TagsResponse, AnyError>)->Void) {
		service.get("tags", nil, completion)
	}

	// MARK: - Campaigns

	func getCampaign(with id:Int,
					 _ completion: @escaping (Result<CampaignResponse, AnyError>)->Void) {
		service.get("campaign/\(id)", nil, completion)
	}

	func getCampaignList(for query:CampaignQuery?,
						 _ completion: @escaping (Result<CampaignListResponse, AnyError>)->Void) {
		if let query = query, query.requestType != .regular {
			guard let token = Service.tokenManager.getToken() else {
				return completion(.failure(AnyError(AuthError.noToken)))
			}
			switch query.requestType {
			case .backed:
				return service.get("campaigns/\(token)/backed", nil, completion)
			case .subscribed:
				return service.get("campaigns/\(token)/subscribed", nil, completion)
			default: break
			}
		}
		let request = CampaignListRequest(from: query)
		service.get("campaigns", request.toDictionary(), completion)
	}

	// MARK: - Subscriptions

	func getSubscriptionStatus(for campaign:Campaign,
							   _ completion: @escaping (Result<BoolResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}

		let request = CampaignRequest(campaignId: campaign.id)
		service.get("user/\(token)/is_subscribed", request.toDictionary(), completion)
	}

	func setSubscribing(_ subscribing:Bool,
						to campaign:Campaign,
						_ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}

		let request = CampaignRequest(campaignId: campaign.id)
		let action = subscribing ? "subscribe" : "unsubscribe"
		service.post("user/\(token)/campaign_\(action)", request.toDictionary(), completion)
	}

	// MARK: - Updates

	func getUpdateList(for campaign:Campaign,
					   _ completion: @escaping (Result<UpdateListResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/updates", nil, completion)
	}

	func getActivity(_ completion: @escaping (Result<ActivityListResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		service.get("user/\(token)/activity", nil, completion)
	}

	func getVoteNotifications(_ completion: @escaping (Result<ActiveVotesResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		service.get("user/\(token)/votes", nil, completion)
	}

	// MARK: - HTML Description

	func getUpdateDescription(for update:Update,
							  in campaign:Campaign,
							  _ completion: @escaping (Result<HTMLResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/update/\(update.id)/description", nil, completion)
	}

	func getCampaignContent(for campaign:Campaign,
							_ completion: @escaping (Result<HTMLResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/content", nil, completion)
	}

	func getUpdateContent(for update:Update,
						  _ completion: @escaping (Result<HTMLResponse, AnyError>)->Void) {
		service.get("update/\(update.id)/content", nil, completion)
	}

	// MARK: - Milestones

	func getMilestones(for campaign:Campaign,
					   _ completion: @escaping (Result<MilestoneListResponse, AnyError>)->Void) {
		service.get("campaign/\(campaign.id)/milestones", nil, completion)
	}

	// MARK: - Contributions

	func getDidContribute(campaignId:Int,
						  _ completion: @escaping (Result<BoolResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		let request = CampaignRequest(campaignId: campaignId)
		service.get("user/\(token)/did_contribute", request.toDictionary(), completion)
	}

	func getDidVote(campaignId:Int,
						  _ completion: @escaping (Result<BoolResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		let request = CampaignRequest(campaignId: campaignId)
		service.get("user/\(token)/did_vote", request.toDictionary(), completion)
	}

	func notifyVote(campaignId:Int,
					value:Bool,
					transactionId:String,
					_ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		let request = VoteNotificationRequest(vote: value,
											  campaignId: campaignId,
											  transactionId: transactionId)
		service.post("user/\(token)/vote", request.toDictionary(), completion)
	}

	func notifyContribution(campaignId:Int,
							amount:Double,
							transactionId:String,
							_ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		let request = ContributionNotificationRequest(amount: amount,
													  campaignId: campaignId,
													  transactionId: transactionId)
		service.post("user/\(token)/contributions", request.toDictionary(), completion)
	}

	func getContributionHistory(
		_ completion: @escaping (Result<ContributionHistoryResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		service.get("user/\(token)/contributions", nil, completion)
	}

	func getVoteResult(campaignId:Int,
					   _ completion: @escaping (Result<VotesResultsResponse, AnyError>)->Void) {
		service.get("campaign/\(campaignId)/vote_results", nil, completion)
	}

	func getVoteInfo(campaignId:Int,
					   _ completion: @escaping (Result<VoteInfoResponse, AnyError>)->Void) {
		service.get("campaign/\(campaignId)/votes", nil, completion)
	}

	// MARK: - Comments

	func likeComment(_ comment:Comment,
					 value:Bool,
					 _ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		let request = CommentLikeRequest(token: token, value: value)
		service.post("comment/\(comment.id)/like", request.toDictionary(), completion)
	}

	func postComment(_ text:String,
					 source: CommentSource,
					 _ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AnyError(AuthError.noToken)))
		}
		let request = CommentRequest(from: source, token: token, text: text)
		service.post("comments", request.toDictionary(), completion)
	}

	func getComments(for query:CommentQuery,
					 _ completion: @escaping (Result<CommentListResponse, AnyError>)->Void) {
		let token = Service.tokenManager.getToken()
		let request = CommentListRequest(from: query, token:token)
		service.get("comments", request.toDictionary(), completion)
	}
}
