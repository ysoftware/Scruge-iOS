//
//  CampaignAVM.swift
//  Scruge
//
//  Created by ysoftware on 24/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class CampaignLisVM: ArrayViewModel<Campaign, CampaignVM, CampaignQuery> {

	override func fetchData(_ query: CampaignQuery?,
							_ block: @escaping (Result<[Campaign], AnyError>) -> Void) {
		Api().getCampaignList(for: query, completion: block)
	}
}
