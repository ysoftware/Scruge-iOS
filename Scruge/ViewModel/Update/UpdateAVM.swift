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

	let campaign:Campaign?

	init(_ campaign:Campaign) {
		self.campaign = campaign
	}

	init(_ updates:[Update]) {
		campaign = nil
		super.init()
		manageItems(updates)
	}

	override func fetchData(_ block: @escaping (Result<[Update], AnyError>) -> Void) {
		guard let campaign = campaign else { return }
		Api().getUpdateList(for: campaign) { result in
			switch result {
			case .success(let response):
				block(.success(response.data))
			case .failure(let error):
				block(.failure(AnyError(error)))
			}
		}
	}
}
