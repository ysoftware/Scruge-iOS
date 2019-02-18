//
//  BountyAVM.swift
//  Scruge
//
//  Created by ysoftware on 18/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class BountyAVM: SimpleArrayViewModel<Bounty, BountyVM> {

	var projectVM:ProjectVM!

	override func fetchData(_ block: @escaping (Result<[Bounty], AnyError>) -> Void) {
		Service.api.getBounties(for: projectVM) { result in
			block(result.map { $0.bounties })
		}
	}
}
