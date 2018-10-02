//
//  PartialCampVM.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import SwiftDate

final class PartialCampaignVM: ViewModel<PartialCampaign>, PartialCampaignModelHolder, PartialCampaignViewModel {

	typealias Model = PartialCampaign

	var id:String {
		return model?.id ?? ""
	}
}

extension PartialCampaignModelHolder {

	var description: String {
		return model?.description ?? ""
	}

	var title: String {
		return model?.title ?? ""
	}

	var imageUrl:URL? {
		guard let string = model?.imageUrl else { return nil }
		return URL(string: string)
	}

	var progress: Double { // 0 - 1
		guard let model = model else { return 0 }
		return model.raisedAmount / model.fundAmount
	}

	var progressString: String {  // 0% - 100%
		guard let model = model else { return "0% raised" }
		return "\((model.raisedAmount / model.fundAmount * 100).format())% raised"
	}

	var raisedString: String {
		guard let model = model else { return "" }
		return "$\(model.raisedAmount.format()) raised of $\(model.fundAmount.format())"
	}

	var daysLeft: String {
		guard let model = model else { return "" }

		let endDate = Date(milliseconds: model.endTimestamp)
		let now = Date()
		let diff = (endDate - now).in(.day) ?? 0

		return "\(diff) days left"
	}
}

