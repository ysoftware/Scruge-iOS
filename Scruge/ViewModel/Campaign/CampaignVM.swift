//
//  CampaignVM.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class CampaignVM: ViewModel<Campaign>, PartialCampaignProperties {

	private let id:String
	private(set) var state:State = .loading {
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
				self.model = response.data
				self.state = .ready
			case .failure(let error):
				self.model = nil
				self.state = .error(makeError(error))
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

		if let milestone = model.currentMilestone {
			currentMilestoneVM = MilestoneVM(milestone)
		}

		rewardsVM = RewardAVM(model.rewards)
		topCommentsVM = CommentAVM(model.topComments)
	}

	// MARK: - View Models

	private(set) var lastUpdateVM:UpdateVM?

	private(set) var topCommentsVM:CommentAVM?

	private(set) var currentMilestoneVM:MilestoneVM?

	private(set) var rewardsVM:RewardAVM?

	// MARK: - Properties

	var totalCommentsCount:String {
		return "\(model?.totalCommentsCount ?? 0)"
	}

	var mediaUrl:String {
		return model?.mediaUrl ?? ""
	}

	var description:String {
		return model?.description ?? ""
	}

	var title:String {
		return model?.title ?? ""
	}

	var progress:Double { // 0 - 1
		guard let model = model else { return 0 }
		return model.raisedAmount / model.fundAmount
	}

	var progressString:String { // 0% - 100%
		guard let model = model else { return "0% raised" }
		return "\((model.raisedAmount / model.fundAmount * 100).format())% raised"
	}

	var raisedString:String {
		guard let model = model else { return "" }
		return "$\(model.raisedAmount.format()) raised of $\(model.fundAmount.format())"
	}

	var daysLeft:String {
		return "n days left"
	}
}

extension CampaignVM {

	enum State:Equatable {

		case loading, ready, error(String)

		static func ==(lhs:State, rhs:State) -> Bool {
			switch (lhs, rhs) {
			case (.error, .error), (.loading, .loading), (.ready, .ready): return true
			default: return false
			}
		}
	}
}

func makeError(_ error:Error) -> String {
	let m:String
	switch error {
	case NetworkingError.parsingError: m = "Incorrect server response"
	case NetworkingError.connectionProblem: m = "Connection problem"
	default: m = "An error occured"
	}
	return m
}
