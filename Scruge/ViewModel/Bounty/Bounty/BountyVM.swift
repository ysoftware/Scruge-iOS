//
//  BountyVM.swift
//  Scruge
//
//  Created by ysoftware on 18/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM

final class BountyVM: ViewModel<Bounty> {

	var name:String {
		return model?.bountyName ?? ""
	}

	var description:String {
		return model?.bountyDescription ?? ""
	}

	var rewards:String {
		return model?.rewardsDescription ?? ""
	}

	var rules:String {
		return model?.rulesDescription ?? ""
	}

	var date:String {
		guard let timestamp = model?.timestamp, let endTimestamp = model?.endTimestamp else { return "" }
		let start = Date.present(timestamp, as: "d MMM yyyy")
		let end = Date.present(endTimestamp, as: "d MMM yyyy")
		return "\(start) - \(end)"
	}
}
