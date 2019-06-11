//
//  CampaignAVM.swift
//  Scruge
//
//  Created by ysoftware on 24/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM


final class CampaignAVM: ArrayViewModel<PartialCampaign, PartialCampaignVM, CampaignQuery> {

	override init() {
		super.init()
		query = CampaignQuery()
	}

	override func fetchData(_ query: CampaignQuery?,
							_ block: @escaping (Result<[PartialCampaign], Error>) -> Void) {
		Service.api.getCampaignList(for: query) { result in
			block(result.map { $0.campaigns })
		}
	}
}
