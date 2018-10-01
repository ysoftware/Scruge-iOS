//
//  RewardVM.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class RewardVM: ViewModel<Reward> {

	var title:String {
		return model?.title ?? ""
	}

	var amount:String {
		guard let model = model else { return "" }
		return "$\(model.amount) or more"
	}

	var description:String {
		return model?.description ?? ""
	}

	var availableString:String? {
		guard let totalAvailable = model?.totalAvailable, let available = model?.available
			else { return nil }
		return "\(available) left of \(totalAvailable)"
	}
}
