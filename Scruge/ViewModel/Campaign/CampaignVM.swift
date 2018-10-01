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
		notifyUpdated()
	}

	public func load() {
		Service.api.getCampaign(with: id) { result in
			switch result {
			case .success(let response):
				self.model = response.data
			case .failure:
				self.model = nil
				// TO-DO: display error maybe
			}
			self.resetViewModels()
			self.notifyUpdated()
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

	func resetViewModels() {
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

	var mediaUrl:String {
		return model?.mediaUrl ?? ""
	}

	var description:String {
		return model?.description ?? ""
	}

	var title:String {
		return model?.title ?? ""
	}

	var progress:Double {
		guard let model = model else { return 0 }
		return model.raisedAmount / model.fundAmount
	}

	var raisedString:String {
		guard let model = model else { return "" }
		return "$\(model.raisedAmount) raised of $\(model.fundAmount)"
	}

	var daysLeft:String {
		return "n days left"
	}
}
