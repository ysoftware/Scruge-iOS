//
//  CampaignVM.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class CampaignVM: ViewModel<Campaign> {

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
		Api().getCampaign(with: id) { result in
			switch result {
			case .success(let response):
				self.model = response.data
				self.notifyUpdated()
			case .failure(_):
				self.model = nil
				self.notifyUpdated()
				// TO-DO: display error maybe
			}
		}
	}
}

final class PartialCampaignVM: ViewModel<PartialCampaign> {

	var imageUrl:String {
		return model?.image ?? ""
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

	var subTitle:String {
		guard let model = model else { return "" }
		return "$\(model.raisedAmount) raised of $\(model.fundAmount)"
	}

	var daysLeft:String {
		return "n days left"
	}

	var raisedText:String {
		guard let model = model else { return "..." }
		return "raised \(model.raisedAmount)"
	}
}
