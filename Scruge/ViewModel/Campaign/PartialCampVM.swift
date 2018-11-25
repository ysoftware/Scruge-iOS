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

	var id:Int {
		return model?.id ?? 0
	}
}

extension PartialCampaignModelHolder {

	var description: String {
		return "Me.guided is the social network for audio guides on blockchain. Users will create new audio tours and sell them on our platform. Me.guided is the new way of exploring world"//model?.description ?? ""
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
		return "\((progress * 100).formatRounding())% raised"
	}

	var raisedString: String {
		guard let model = model else { return "" }
		let raised = model.economics.raised.format(as: .decimal, separateWith: " ")
		let total = model.economics.softCap.format(as: .decimal, separateWith: " ")
		return "$\(raised) raised of $\(total)"
	}

	var daysLeft: String {
		guard let model = model else { return "" }
		let end = Date(milliseconds: model.endTimestamp)
		return end.toRelative(locale: Locales.english)
	}
}
