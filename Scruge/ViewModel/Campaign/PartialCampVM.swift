//
//  PartialCampVM.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import SwiftDate

final class PartialCampaignVM: ViewModel<PartialCampaign>,
		PartialCampaignModelHolder, PartialCampaignViewModel {

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
		return model.economics.raised / model.economics.softCap
	}

	var progressString: String {  // 0% - 100%
		guard let model = model else { return "0% raised" }
		let progress = (model.economics.raised / model.economics.softCap * 100).formatRounding()
		return "\(progress)% raised"
	}

	var raisedString: String {
		guard let model = model else { return "" }
		let raised = model.economics.raised.format(as: .decimal, separateWith: " ")
		let total = model.economics.softCap.format(as: .decimal, separateWith: " ")
		return "$\(raised) raised of $\(total)"
	}

	var daysLeft: String {
		guard let model = model else { return "" }

		let d = Date(milliseconds: model.endTimestamp) - Date()
		let diff = d.timeInterval.toString {
			$0.maximumUnitCount = 1
			$0.zeroFormattingBehavior = .dropAll
			$0.allowedUnits = [ .month, .day, .hour, .minute]
			$0.collapsesLargestUnit = true
			$0.unitsStyle = .full
		}
		return "\(diff) left"
	}
}
