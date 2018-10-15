//
//  CampaignAVM.swift
//  Scruge
//
//  Created by ysoftware on 24/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class CampaignAVM: ArrayViewModel<PartialCampaign, PartialCampaignVM, CampaignQuery> {

	override init() {
		super.init()
		query = CampaignQuery()
	}

	override func fetchData(_ query: CampaignQuery?,
							_ block: @escaping (Result<[PartialCampaign], AnyError>) -> Void) {
		Service.api.getCampaignList(for: query) { result in
			switch result {
			case .success(let response):
				block(.success(response.campaigns))
			case .failure(let error):
				block(.failure(AnyError(error)))
			}
		}
	}
}
