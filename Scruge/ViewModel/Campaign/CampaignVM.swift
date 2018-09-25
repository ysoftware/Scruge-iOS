//
//  CampaignVM.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation
import MVVM

final class CampaignVM: ViewModel<Campaign> {

	public func load(id:String) {
		Api().getCampaign(with: id) { result in
			switch result {
			case .success(let response):
				self.model = response.campaign
				self.notifyUpdated()
			case .failure(_):
				self.model = nil
				self.notifyUpdated()
				// TO-DO: display error maybe
			}
		}
	}
}
