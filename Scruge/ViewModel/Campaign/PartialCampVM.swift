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
		return model?.description ?? ""
	}

	var title: String {
		return model?.title ?? ""
	}

	var imageUrl:URL? {
		guard let string = model?.imageUrl else { return nil }
		return URL(string: string)
	}

	var raised: Double {
		guard let model = model else { return 0 }
		return model.economics.raised.rounded()
	}

	var hardCap: Int {
		guard let model = model else { return 0 }
		return model.economics.hardCap
	}

	var softCap: Int {
		guard let model = model else { return 0 }
		return model.economics.softCap
	}

	var daysLeft: String {
		guard let model = model else { return "" }
		let end = Date(milliseconds: model.endTimestamp)
		return end.toRelative(locale: Locales.english)
	}
}
