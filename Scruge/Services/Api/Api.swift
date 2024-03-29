//
//  API.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//


import SwiftHTTP
import FirebaseMessaging
import FirebaseCore
import FirebaseInstanceID

final class Api {

	public static let version = 1

	enum Environment:String {

		case test = "http://testapi.scruge.world/"

		case prod = "https://api.scruge.world/"

		case dev = "http://176.213.156.167/"
	}

	// MARK: - Initialization

	private(set) var service:Networking = Network(baseUrl: Environment.prod.rawValue, apiVersion: version)

	func setEnvironment(_ environment:Environment) {
		service = Network(baseUrl: environment.rawValue, apiVersion: Api.version)
	}

	func getInfo(_ completion: @escaping (Result<GeneralInfoResponse, Error>)->Void) {
		service.get("", nil, completion)
	}

	// MARK: - Bounty

	func getProjects(_ completion: @escaping (Result<ProjectsResponse, Error>)->Void) {
		service.get("projects", nil, completion)
	}

	func getBounties(for projectVM:ProjectVM,
					 _ completion: @escaping (Result<BountiesResponse, Error>)->Void) {
		let request = BountiesRequest(providerName: projectVM.providerName)
		service.get("bounties", request.toDictionary(), completion)
	}

	func postSubmission(bountyId:Int64, proof:String, hunterName:String, providerName:String,
						_ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		let request = SubmissionRequest(token: token,
										bountyId: bountyId,
										proof: proof,
										hunterName: hunterName,
										providerName: providerName)
		service.post("submissions", request.toDictionary(), completion)
	}

	// MARK: - Wallet

	func createAccount(withName accountName: String,
					   publicKey: String,
					   _ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		let request = AccountRequest(name: accountName, publicKey: publicKey)
		service.post("user/\(token)/create_eos_account", request.toDictionary(), completion)
	}

	func getDefaultTokens(_ completion: @escaping (Result<[Token], Error>)->Void) {
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

	func resetPassword(login:String, _ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		let request = LoginRequest(login: login)
		service.post("auth/reset_password", request.toDictionary(), completion)
	}

	func logIn(email:String,
			   password:String,
			   _ completion: @escaping (Result<LoginResponse, Error>)->Void) {
		InstanceID.instanceID().instanceID { result, _ in
			let token = result?.token
			let request = AuthRequest(login: email, password: password, token: token)
			self.service.post("auth/login", request.toDictionary(), completion)
		}
	}

	func signUp(email:String,
				password:String,
				_ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		let request = RegisterRequest(login: email, password: password)
		service.post("auth/register", request.toDictionary(), completion)
	}

	func checkEmail(_ email:String,
					_ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		let request = EmailRequest(email: email)
		service.post("auth/check_email", request.toDictionary(), completion)
	}

	// MARK: - Profile

	func getUserId(_ completion: @escaping (Result<UserIdResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		service.get("user/\(token)/id", nil, completion)
	}

	func updateProfileImage(_ image:UIImage,
							_ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		guard let data = image.jpegData(compressionQuality: 0.8) else {
			return completion(.failure(BackendError.parsingError))
		}
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
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
					   _ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		let request = ProfileRequest(name: name, country: country, description: description)
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		service.put("profile/\(token)", request.toDictionary(), completion)
	}

	func getProfile(_ completion: @escaping (Result<ProfileResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		service.get("profile/\(token)", nil, completion)
	}

	// MARK: - Categories & Tags

	func getCategories(_ completion: @escaping (Result<CategoriesResponse, Error>)->Void) {
		service.get("categories", nil, completion)
	}

	func getTags(_ completion: @escaping (Result<TagsResponse, Error>)->Void) {
		service.get("tags", nil, completion)
	}

	// MARK: - Campaigns

	func getCampaign(with id:Int,
					 _ completion: @escaping (Result<CampaignResponse, Error>)->Void) {
		service.get("campaign/\(id)", nil, completion)
	}

	func getCampaignList(for query:CampaignQuery?,
						 _ completion: @escaping (Result<CampaignListResponse, Error>)->Void) {
		if let query = query, query.requestType != .regular {
			guard let token = Service.tokenManager.getToken() else {
				return completion(.failure(AuthError.noToken))
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
							   _ completion: @escaping (Result<BoolResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}

		let request = CampaignRequest(campaignId: campaign.id)
		service.get("user/\(token)/is_subscribed", request.toDictionary(), completion)
	}

	func setSubscribing(_ subscribing:Bool,
						to campaign:Campaign,
						_ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}

		let request = CampaignRequest(campaignId: campaign.id)
		let action = subscribing ? "subscribe" : "unsubscribe"
		service.post("user/\(token)/campaign_\(action)", request.toDictionary(), completion)
	}

	// MARK: - Updates

	func getUpdateList(for campaign:Campaign,
					   _ completion: @escaping (Result<UpdateListResponse, Error>)->Void) {
		service.get("campaign/\(campaign.id)/updates", nil, completion)
	}

	func getActivity(query:ActivityQ?,
					 _ completion: @escaping (Result<ActivityListResponse, Error>)->Void) {
		let params = ActivityListRequest(page: query?.page ?? 0)
		guard let token = Service.tokenManager.getToken() else {
			return service.get("activity", params.toDictionary(), completion)
		}
		service.get("user/\(token)/activity", params.toDictionary(), completion)
	}

	func getVoteNotifications(_ completion: @escaping (Result<ActiveVotesResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		service.get("user/\(token)/votes", nil, completion)
	}

	// MARK: - HTML Description

	func getUpdateDescription(for update:Update,
							  in campaign:Campaign,
							  _ completion: @escaping (Result<HTMLResponse, Error>)->Void) {
		service.get("campaign/\(campaign.id)/update/\(update.id)/description", nil, completion)
	}

	func getCampaignContent(for campaign:Campaign,
							_ completion: @escaping (Result<HTMLResponse, Error>)->Void) {
		service.get("campaign/\(campaign.id)/content", nil, completion)
	}

	func getUpdateContent(for update:Update,
						  _ completion: @escaping (Result<HTMLResponse, Error>)->Void) {
		service.get("update/\(update.id)/content", nil, completion)
	}

	// MARK: - Milestones

	func getMilestones(for campaign:Campaign,
					   _ completion: @escaping (Result<MilestoneListResponse, Error>)->Void) {
		service.get("campaign/\(campaign.id)/milestones", nil, completion)
	}

	// MARK: - Contributions

	func getDidContribute(campaignId:Int,
						  _ completion: @escaping (Result<BoolResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		let request = CampaignRequest(campaignId: campaignId)
		service.get("user/\(token)/did_contribute", request.toDictionary(), completion)
	}

	func getDidVote(campaignId:Int,
						  _ completion: @escaping (Result<BoolResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		let request = CampaignRequest(campaignId: campaignId)
		service.get("user/\(token)/did_vote", request.toDictionary(), completion)
	}

	func notifyVote(campaignId:Int,
					value:Bool,
					transactionId:String,
					_ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		let request = VoteNotificationRequest(vote: value,
											  campaignId: campaignId,
											  transactionId: transactionId)
		service.post("user/\(token)/vote", request.toDictionary(), completion)
	}

	func notifyContribution(campaignId:Int,
							amount:Double,
							transactionId:String,
							_ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		let request = ContributionNotificationRequest(amount: amount,
													  campaignId: campaignId,
													  transactionId: transactionId)
		service.post("user/\(token)/contributions", request.toDictionary(), completion)
	}

	func getContributionHistory(
		_ completion: @escaping (Result<ContributionHistoryResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		service.get("user/\(token)/contributions", nil, completion)
	}

	func getVoteResult(campaignId:Int,
					   _ completion: @escaping (Result<VotesResultsResponse, Error>)->Void) {
		service.get("campaign/\(campaignId)/vote_results", nil, completion)
	}

	func getVoteInfo(campaignId:Int,
					   _ completion: @escaping (Result<VoteInfoResponse, Error>)->Void) {
		service.get("campaign/\(campaignId)/votes", nil, completion)
	}

	// MARK: - Comments

	func likeComment(_ comment:Comment,
					 value:Bool,
					 _ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		let request = CommentLikeRequest(token: token, value: value)
		service.post("comment/\(comment.id)/like", request.toDictionary(), completion)
	}

	func postComment(_ text:String,
					 source: CommentSource,
					 _ completion: @escaping (Result<ResultResponse, Error>)->Void) {
		guard let token = Service.tokenManager.getToken() else {
			return completion(.failure(AuthError.noToken))
		}
		let request = CommentRequest(from: source, token: token, text: text)
		service.post("comments", request.toDictionary(), completion)
	}

	func getComments(for query:CommentQuery,
					 _ completion: @escaping (Result<CommentListResponse, Error>)->Void) {
		let token = Service.tokenManager.getToken()
		let request = CommentListRequest(from: query, token:token)
		service.get("comments", request.toDictionary(), completion)
	}
}
