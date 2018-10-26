//
//  UpdateAVM.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class UpdateAVM: SimpleArrayViewModel<Update, UpdateVM> {

	enum Source {

		case campaign(Campaign)

		case activity
	}

	private let source:Source

	init(_ source:Source) {
		self.source = source
	}

	init(_ updates:[Update], for campaign:Campaign) {
		self.source = .campaign(campaign)
		super.init()
		setData(updates.map { UpdateVM($0) })
	}

	override func fetchData(_ block: @escaping (Result<[Update], AnyError>) -> Void) {
		switch source {
		case .campaign(let campaign):
			Service.api.getUpdateList(for: campaign) { result in
				switch result {
				case .success(let response):
					block(.success(response.updates))
				case .failure(let error):
					block(.failure(AnyError(error)))
				}
			}
		case .activity:
			Service.api.getActivity { result in
				switch result {
				case .success(let response):
					let updates = response.updates.map { activity -> Update in
						var update = activity.update
						update.campaignInfo = activity.campaign
						return update
					}
					block(.success(updates))
				case .failure(let error):
					block(.failure(AnyError(error)))
				}
			}
		}
	}
}
