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
		Api.getCampaign { campaign in
			self.model = campaign
			self.notifyUpdated()
		}
	}
}
