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

	private let campaign:Campaign

	init(_ campaign:Campaign) {
		self.campaign = campaign
	}

	init(_ updates:[Update], for campaign:Campaign) {
		self.campaign = campaign
		super.init()
		setData(updates.map { UpdateVM($0) })
	}

	override func fetchData(_ block: @escaping (Result<[Update], AnyError>) -> Void) {
		Service.api.getUpdateList(for: campaign) { result in
			switch result {
			case .success(let response):
				block(.success(response.updates))
			case .failure(let error):
				block(.failure(AnyError(error)))
			}
		}
	}
}
