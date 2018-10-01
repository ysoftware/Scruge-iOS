//
//  MilestoneVM.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class MilestoneVM: ViewModel<Milestone> {

	var description:String {
		return model?.description ?? ""
	}

	var date:String {
		return "January 1, 2019" //model?.endTimestamp
	}
}
