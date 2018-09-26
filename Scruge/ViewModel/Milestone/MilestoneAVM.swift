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

	override func fetchData(_ block: @escaping (Result<[Milestone], AnyError>) -> Void) {
		
	}
}
