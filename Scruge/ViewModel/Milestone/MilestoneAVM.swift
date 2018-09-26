//
//  MilestoneAVM.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class MilestoneAVM: SimpleArrayViewModel<Milestone, MilestoneVM> {

	let campaign:Campaign?

	init(_ campaign:Campaign) {
		self.campaign = campaign
	}

	init(_ milestones:[Milestone]) {
		campaign = nil
		super.init()
		manageItems(milestones)
	}

	override func fetchData(_ block: @escaping (Result<[Milestone], AnyError>) -> Void) {
		guard let campaign = campaign else { return }
		Api().getMilestones(for: campaign) { result in
			switch result {
			case .success(let response):
				block(.success(response.milestones))
			case .failure(let error):
				block(.failure(AnyError(error)))
			}
		}
	}
}
