//
//  RewardAVM.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM


final class RewardAVM: SimpleArrayViewModel<Reward, RewardVM> {

	init(_ rewards:[Reward]) {
		super.init()
		setData(rewards.map { RewardVM($0) })
	}

	override func fetchData(_ block: @escaping (Result<[Reward], Error>) -> Void) {
		// no op?
	}
}
