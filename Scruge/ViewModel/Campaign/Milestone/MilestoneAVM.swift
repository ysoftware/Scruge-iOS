//
//  MilestoneAVM.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class MilestoneAVM: SimpleArrayViewModel<Milestone, MilestoneVM> {

	private let campaign:Campaign?

	init(_ campaign:Campaign) {
		self.campaign = campaign
	}

	init(_ milestones:[Milestone]) {
		campaign = nil
		super.init()
		setData(milestones.map { MilestoneVM($0) })
	}

	override func fetchData(_ block: @escaping (Result<[Milestone], Error>) -> Void) {
		guard let campaign = campaign else { return }
		Service.api.getMilestones(for: campaign) { block($0.map { $0.milestones }) }
	}
}
