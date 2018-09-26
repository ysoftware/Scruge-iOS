//
//  CampaignVM.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

protocol PartialCampaignVMProtocol {

}

final class CampaignVM: ViewModel<Campaign>, PartialCampaignVMProtocol {

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

final class PartialCampaignVM: ViewModel<PartialCampaign>, PartialCampaignVMProtocol {

}
