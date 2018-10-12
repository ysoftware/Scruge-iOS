//
//  CampaignVM.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class CampaignVM: ViewModel<Campaign>, PartialCampaignViewModel, PartialCampaignModelHolder {

	typealias Model = Campaign

	private let id:String
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

	public func load() {
		state = .loading
		Service.api.getCampaign(with: id) { result in
			switch result {
			case .success(let response):
				self.model = response.campaign
				self.state = .ready
			case .failure(let error):
				self.model = nil
				self.state = .error(ErrorHandler.message(for: error))
			}
			self.resetViewModels()
		}
	}

	public func loadDescription(_ completion: @escaping (String)->Void) {
		guard let model = model else { return completion("") }
		Service.api.getCampaignDescription(for: model) { result in
			if case let .success(response) = result {
				completion(response.data)
			}
			else {
				completion("")
			}
		}
	}

	private func resetViewModels() {
		guard let model = model else { return }

		if let update = model.lastUpdate {
			lastUpdateVM = UpdateVM(update)
		}
		else {
			lastUpdateVM = nil
		}

		if let milestone = model.currentMilestone {
			currentMilestoneVM = MilestoneVM(milestone)
		}
		else {
			currentMilestoneVM = nil
		}

		if let rewards = model.rewards {
			rewardsVM = RewardAVM(rewards)
		}
		else {
			rewardsVM = nil
		}

		if let comments = model.topComments {
			topCommentsVM = CommentAVM(comments, source: .campaign(model))
		}
		else {
			topCommentsVM = nil
		}

		if let documents = model.documents {
			documentsVM = DocumentAVM(documents)
		}
		else {
			documentsVM = nil
		}

		if let faq = model.faq {
			faqVM = FaqAVM(faq)
		}
		else {
			faqVM = nil
		}
	}

	// MARK: - View Models

	private(set) var lastUpdateVM:UpdateVM?

	private(set) var topCommentsVM:CommentAVM?

	private(set) var currentMilestoneVM:MilestoneVM?

	private(set) var rewardsVM:RewardAVM?

	private(set) var documentsVM:DocumentAVM?

	private(set) var faqVM:FaqAVM?

	// MARK: - Properties

	var social:[SocialElement] {
		return model?.social?.map { key, value in
			guard let type = SocialNetwork(rawValue: key) else { return nil }
			return SocialElement(url: value, type: type)
			}.compactMap { $0 } ?? []
	}

	var about:String? {
		return model?.about
	}

	var status:Status {
		guard let model = model else { return .none }

		// campaign is not over
		if model.endTimestamp > Date().milliseconds {
			return .contribute
		}

		// TO-DO: add voting too

		return .none
	}

	var videoUrl:URL? {
		guard let model = model else { return nil }
		return URL(string: model.videoUrl)
	}

	var totalCommentsCount:String {
		return "\(model?.totalCommentsCount ?? 0)"
	}

	enum Status {

		case contribute, vote, none
	}
}
