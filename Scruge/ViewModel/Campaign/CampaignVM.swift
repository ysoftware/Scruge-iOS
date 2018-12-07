//
//  CampaignVM.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class CampaignVM: ViewModel<Campaign>, PartialCampaignViewModel, PartialCampaignModelHolder {

	enum Status: Int, Codable {

		/// contributions allowed
		case funding = 0

		/// waiting for milestone
		case milestone = 1

		/// ongoing vote
		case activeVote = 2

		/// waiting for founder action
		case waiting = 3

		/// campaign done
		case closed = 4
	}

	private let id:Int
	private(set) var isSubscribed:Bool? { didSet { notifyUpdated() }}
	private(set) var canVote:Bool? { didSet { notifyUpdated() }}
	private(set) var isBacker:Bool? { didSet { notifyUpdated() }}
	private(set) var state:ViewState = .loading  { didSet { notifyUpdated() }}

	// MARK: - Setup

	init(_ id:Int) {
		self.id = id
		super.init()
		load()
	}

	required init(_ model: Campaign, arrayDelegate: ViewModelDelegate?) {
		id = model.id
		super.init(model, arrayDelegate: arrayDelegate)
		state = .ready
	}

	private func resetViewModels() {
		if let update = model?.lastUpdate { lastUpdateVM = UpdateVM(update) }
		else { lastUpdateVM = nil }

		if let milestone = model?.currentMilestone { currentMilestoneVM = MilestoneVM(milestone) }
		else { currentMilestoneVM = nil }

		if let model = model {
			milestonesVM = MilestoneAVM(model)
			milestonesVM?.reloadData()
		}
		else { milestonesVM = nil }

		if let model = model, let comments = model.topComments {
			topCommentsVM = CommentAVM(comments, source: .campaign(model))
		}
		else { topCommentsVM = nil }

		if let model = model {
			var documents:[Document] = []
			if let pitch = model.pitchUrl {
				documents.append(Document(name: "Pitch", url: pitch))
			}
			else {
				let url = Service.api.service.baseUrl + "campaign/\(model.id)/content"
				documents.append(Document(name: "Pitch", url: url))
			}
			if let otherDocs = model.documents {
				documents.append(contentsOf: otherDocs)
			}
			documentsVM = DocumentAVM(documents)
		}
		else { documentsVM = nil }

		if let faq = model?.faq { faqVM = FaqAVM(faq) }
		else { faqVM = nil }

		if let economics = model?.economics { economiesVM = EconomiesVM(economics) }
		else { economiesVM = nil }
	}

	// MARK: - Methods

	func loadDescription(_ completion: @escaping (String)->Void) {
		guard let model = model else { return completion("") }
		Service.api.getCampaignContent(for: model) { result in
			guard case let .success(response) = result else {
				return completion("")

			}
			completion(response.content)
		}
	}

	func loadVoteInfo(_ completion: @escaping (VoteInfo?)->Void) {
		guard let model = model else { return completion(nil) }
		Service.api.getVoteInfo(campaignId: model.id) { result in
			guard case let .success(response) = result else {
				return completion(nil)
			}
			completion(response.voting)
		}
	}

	func loadVoteResults(_ completion: @escaping (VoteResult?)->Void) {
		guard let model = model else { return completion(nil) }
		Service.api.getVoteResult(campaignId: model.id) { result in
			guard case let .success(response) = result else {
				return completion(nil)
			}
			completion(response.votings.first(where: { $0.active }))
		}
	}

	func loadAmountContributed(_ completion: @escaping (Double?)->Void) {
		guard let model = model else { return completion(nil) }

		Service.api.getContributionHistory { response in
			switch response {
			case .failure:
				completion(nil)
			case .success(let result):
				let contribution = result.contributions.first(where: { $0.campaignId == model.id })
				completion(contribution?.amount ?? 0)
			}
		}
	}

	// MARK: - Actions

	func load() {
		state = .loading
		reloadData()
	}

	func reloadData() {
		Service.api.getCampaign(with: id) { result in
			switch result {
			case .success(let response):
				self.model = response.campaign
				self.reloadSubscribtionStatus()
				self.reloadCanVote()
				self.state = .ready
			case .failure(let error):
				self.model = nil
				self.state = .error(ErrorHandler.message(for: error))
			}
			self.resetViewModels()
		}
	}

	func contribute(_ amount:Double,
					account:AccountVM,
					passcode:String,
					completion: @escaping (Error?)->Void) {

		guard let model = model,
			let account = account.model
			else { return completion(WalletError.noAccounts) }

		Service.api
			.getUserId { userResult in

				guard case let .success(response) = userResult else {
					return completion(userResult.error!)
				}

				Service.eos
					.sendMoney(from: account,
							   to: EOS.contractAccount,
							   amount: amount,
							   symbol: "SCR",
							   memo: "\(response.userId)-\(model.id)",
					passcode: passcode) { transactionResult in

						guard case let .success(transactionId) = transactionResult else {
							return completion(transactionResult.error!)
						}

						Service.api
							.notifyContribution(campaignId: model.id,
												amount: amount,
												transactionId: transactionId) { result in

													// если ошибка
													// не удалось уведомить сервер о транзакции
													// но она прошла успешно
													completion(nil)
						}
				}
		}
	}

	func vote(_ value:Bool,
			  account:AccountVM,
			  passcode:String,
			  completion: @escaping (Error?)->Void) {

		guard let model = model,
			let account = account.model
			else { return completion(WalletError.noAccounts) }

		Service.api
			.getUserId { userResult in

				guard case let .success(response) = userResult else {
					return completion(userResult.error!)
				}

				let vote = Vote(eosAccount: account.name,
								userId: response.userId,
								campaignId: model.id,
								vote: value)

				Service.eos
					.sendAction("vote",
								from: account,
								data: vote.jsonString,
								passcode: passcode) { transactionResult in

									guard case let .success(transactionId) = transactionResult else {
										return completion(transactionResult.error!)
									}

									Service.api
										.notifyVote(campaignId: model.id,
													value: value,
													transactionId: transactionId) { result in

														// если ошибка
														// не удалось уведомить сервер о транзакции
														// но она прошла успешно
														completion(nil)
									}
				}
		}
	}

	func toggleSubscribing() {
		guard let model = model,
			let isSubscribed = isSubscribed
			else { return }

		let newValue = !isSubscribed
		Service.api.setSubscribing(newValue, to: model) { result in
			if case .success = result {
				self.reloadSubscribtionStatus()
			}
		}
	}

	private func reloadSubscribtionStatus() {
		guard let model = model else { return }
		Service.api.getSubscriptionStatus(for: model) { result in
			switch result {
			case .success(let response):
				self.isSubscribed = response.value
			case .failure:
				self.isSubscribed = nil
			}
		}
	}

	private func reloadCanVote() {
		guard let model = model else { return }
		Service.api.getDidContribute(campaignId: model.id) { didContributeResult in
			guard
				case let .success(contributeResponse) = didContributeResult else {
				self.canVote = false // not an investor
				self.isBacker = false
				return
			}

			self.isBacker = contributeResponse.value

			// check if voted already
			Service.api.getDidVote(campaignId: model.id) { didVoteResult in
				guard case let .success(voteResponse) = didVoteResult else {
					self.canVote = false
					return
				}

				self.canVote = !voteResponse.value
			}
		}
	}

	// MARK: - View Models

	private(set) var lastUpdateVM:UpdateVM?

	private(set) var topCommentsVM:CommentAVM?

	private(set) var currentMilestoneVM:MilestoneVM?

	private(set) var milestonesVM:MilestoneAVM?

	private(set) var economiesVM:EconomiesVM?

	private(set) var documentsVM:DocumentAVM?

	private(set) var faqVM:FaqAVM?

	// MARK: - Properties

	var team:[Member] {
		return model?.team ?? []
	}

	var commentsCount:Int {
		return model?.totalCommentsCount ?? 0
	}

	var social:[Social] {
		return model?.social ?? []
	}

	var about:String {
		return model?.about ?? ""
	}

	var status:Status {
		return model.flatMap { Status(rawValue: $0.status) } ?? .closed
	}

	var videoUrl:URL? {
		return model.flatMap {
			URL(string: $0.videoUrl.replacingOccurrences(of: "controls=0", with: ""))
		}
	}
}
