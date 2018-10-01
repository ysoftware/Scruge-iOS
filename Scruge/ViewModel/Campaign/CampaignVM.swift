//
//  CampaignVM.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class CampaignVM: ViewModel<Campaign>, PartialCampaignProperties {

	let id:String

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
				self.notifyUpdated()
			case .failure:
				self.model = nil
				self.notifyUpdated()
				// TO-DO: display error maybe
			}
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

final class PartialCampaignVM: ViewModel<PartialCampaign>, PartialCampaignProperties {

	var id:String {
		return model?.id ?? ""
	}

	var imageUrl:String {
		return model?.imageUrl ?? ""
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

// MARK: - Unite these two

protocol PartialCampaignProperties {

	var description:String { get }

	var title:String { get }

	var progress:Double { get }

	var raisedString:String { get }

	var daysLeft:String { get }
}

