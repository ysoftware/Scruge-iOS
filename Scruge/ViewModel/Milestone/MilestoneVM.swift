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
		guard let model = model else { return "" }
		return Date.present(model.endTimestamp, as: "d MMMM yyyy")
	}
}
