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

		case idle = 0

		case contribute = 1

		case voteDeadline = 2

		case voteMilestone = 3
	}
	
	typealias Model = Campaign

	private let id:String

	private(set) var isSubscribed:Bool = false
	private(set) var state:ViewState = .loading {
		didSet {
			notifyUpdated()
		}
	}

	// MARK: - Setup

	init(_ id:String) {
		self.id = id
		super.init()
		load()
	}

	required init(_ model: Campaign, arrayDelegate: ViewModelDelegate?) {
		id = model.id
		super.init()
		self.arrayDelegate = arrayDelegate
		self.model = model
		state = .ready
	}

	private func resetViewModels() {
		if let update = model?.lastUpdate {
			lastUpdateVM = UpdateVM(update)
		}
		else {
			lastUpdateVM = nil
		}

		if let milestone = model?.currentMilestone {
			currentMilestoneVM = MilestoneVM(milestone)
		}
		else {
			currentMilestoneVM = nil
		}

		if let model = model, let comments = model.topComments {
			topCommentsVM = CommentAVM(comments, source: .campaign(model))
		}
		else {
			topCommentsVM = nil
		}

		if let documents = model?.documents {
			documentsVM = DocumentAVM(documents)
		}
		else {
			documentsVM = nil
		}

		if let faq = model?.faq {
			faqVM = FaqAVM(faq)
		}
		else {
			faqVM = nil
		}

		// token economies

		var items:[Technical] = []

		if let supply = model?.economics.tokenSupply {
			items.append(Technical(name: "Total token supply",
								   value: supply.format(as: .decimal, separateWith: " "),
				description: "Total amount of tokens to be issued"))
		}

		if let publicTokenPercent = model?.economics.publicTokenPercent {
			items.append(Technical(name: "Token public percent",
								   value: "\(publicTokenPercent)%",
				description: "Percent of all issued tokens to be sold to public"))
		}

		if let inflation = model?.economics.annualInflationPercent {
			items.append(Technical(name: "Annual inflation rate",
								   value: "\(inflation.start)% - \(inflation.end)%",
				description: "Range of annual inflation rate"))
		}

		technicalVM = TechnicalAVM(items)
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
				self.state = .ready
			case .failure(let error):
				self.model = nil
				self.state = .error(ErrorHandler.message(for: error))
			}
			self.resetViewModels()
		}
	}

	func loadDescription(_ completion: @escaping (String)->Void) {
		guard let model = model else { return completion("") }
		Service.api.getCampaignContent(for: model) { result in
			if case let .success(response) = result {
				completion(response.content)
			}
			else {
				completion("")
			}
		}
	}

	func reloadSubscribtionStatus() {
		guard let model = model else { return }
		Service.api.getSubscriptionStatus(for: model) { result in
			switch result {
			case .success(let response):
				self.isSubscribed = response.subscribed
				self.notifyUpdated()
			case .failure(_):
				break
			}
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

	func contribute(_ amount:Double,
					account:AccountVM,
					passcode:String,
					completion: @escaping (Bool)->Void) {

		guard let model = model,
			let account = account.model
			else { return completion(false) }

		Service.api.getProfile { profileResult in

			guard case let .success(response) = profileResult,
				let login = response.profile?.login
				else { return completion(false) }

			Service.eos.sendMoney(from: account,
								  to: "addressbook1",
								  amount: amount,
								  symbol: "SCR",
								  memo: login,
								  passcode: passcode) { transactionId in

									guard let transactionId = transactionId else { return completion(false) }

									Service.api.notifyContribution(campaignId: model.id,
																   amount: amount,
																   transactionId: transactionId) { result in

																	completion(true)
																	// не удалось подтвердить транзакцию
																	// если ошибка
									}
			}
		}
	}

	func toggleSubscribing() {
		guard let model = model else { return }

		let newValue = !isSubscribed
		Service.api.setSubscribing(newValue, to: model) { result in
			switch result {
			case .success(_):
				self.reloadSubscribtionStatus()
			case .failure(_):
				break
			}
		}
	}

	// MARK: - View Models

	private(set) var lastUpdateVM:UpdateVM?

	private(set) var topCommentsVM:CommentAVM?

	private(set) var currentMilestoneVM:MilestoneVM?

	private(set) var technicalVM:TechnicalAVM?

	private(set) var documentsVM:DocumentAVM?

	private(set) var faqVM:FaqAVM?

	// MARK: - Properties

	var contributionInformation:String {
		guard let model = model else { return "" }
		return """
		Minimum contribution: $\(model.economics.minUserContribution)
		Maximum contribution: $\(model.economics.maxUserContribution)
		"""
	}

	var commentsCount:Int {
		return model?.totalCommentsCount ?? 0
	}

	var social:[Social] {
		return model?.social ?? []
	}

	var about:String? {
		return model?.about
	}

	var status:Status {
		guard let state = model?.status, let status = Status(rawValue: state)
			else { return .idle }
		return status
	}

	var videoUrl:URL? {
		guard let model = model else { return nil }
		return URL(string: model.videoUrl
			.replacingOccurrences(of: "controls=0", with: ""))
	}
}
