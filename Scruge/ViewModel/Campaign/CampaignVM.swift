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

		/// not started yet
		case preparing = 100
	}

	private let id:Int
	private(set) var isSubscribed = false
	private(set) var canVote = false
	private(set) var isBacker = false
	private(set) var state:ViewState = .loading

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
		lastUpdateVM = model?.lastUpdate.flatMap { UpdateVM($0) }
		currentMilestoneVM = model?.currentMilestone.flatMap { MilestoneVM($0) }
		faqVM = model?.faq.flatMap { FaqAVM($0) }
		economiesVM = model.flatMap { EconomiesVM($0.economics) }
		topCommentsVM = model.flatMap { CommentAVM($0.topComments, source: .campaign($0)) }
		documentsVM = model?.documents.flatMap { DocumentAVM($0) }

		milestonesVM = model.flatMap { MilestoneAVM($0) }
		milestonesVM?.reloadData()
	}

	// MARK: - Methods

	func loadDescription(_ completion: @escaping (String)->Void) {
		guard let model = model else { return completion("") }
		Service.api.getCampaignContent(for: model) { result in
			completion(result.value?.content ?? "")
		}
	}

	func loadVoteInfo(_ completion: @escaping (VoteInfo?)->Void) {
		guard let model = model else { return completion(nil) }
		Service.api.getVoteInfo(campaignId: model.id) { result in
			completion(result.value?.voting)
		}
	}

	func loadVoteResults(_ completion: @escaping (VoteResult?)->Void) {
		guard let model = model else { return completion(nil) }
		Service.api.getVoteResult(campaignId: model.id) { result in
			completion(result.value?.votings.first(where: { $0.active }))
		}
	}

	func loadAmountContributed(_ completion: @escaping (Double?)->Void) {
		guard let model = model else { return completion(nil) }

		Service.api.getContributionHistory { result in
			let contribution = result.value?.contributions.first(where: { $0.campaignId == model.id })
			completion(contribution?.amount ?? 0)
		}
	}

	// MARK: - Actions

	func load() {
		state = .loading
		reloadData()
	}

	func reloadData() {
		Service.api.getCampaign(with: id) { result in
			self.isBacker = false
			self.isSubscribed = false
			self.canVote = false

			switch result {
			case .success(let response):
				self.model = response.campaign
				self.reloadSubscribtionStatus()
				self.reloadCanVote()
				self.resetViewModels()
				self.state = .ready
			case .failure(let error):
				self.model = nil
				self.resetViewModels()
				self.notifyUpdated()
				self.state = .error(ErrorHandler.message(for: error))
			}
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

				let balance = Balance(token: Token.Scruge, amount: amount)
				Service.eos
					.sendMoney(from: account,
							   to: Service.eos.contractAccount,
							   balance: balance,
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
					.sendAction(EosName.create("vote"),
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
		guard let model = model else { return }

		let newValue = !isSubscribed
		Service.api.setSubscribing(newValue, to: model) { result in
			if case .success(let response) = result, response.result == 0 {
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
				self.isSubscribed = false
			}
			self.notifyUpdated()
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

			guard self.isBacker else {
				self.canVote = false
				return
			}

			// check if voted already
			Service.api.getDidVote(campaignId: model.id) { didVoteResult in
				guard case let .success(voteResponse) = didVoteResult else {
					self.canVote = false
					self.notifyUpdated()
					return
				}

				self.canVote = !voteResponse.value
				self.notifyUpdated()
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

	var startDate:String {
		return model.flatMap { Date.present($0.startTimestamp, as: "MMMM d") } ?? ""
	}

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
