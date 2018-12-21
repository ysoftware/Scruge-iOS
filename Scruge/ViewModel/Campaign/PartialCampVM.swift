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
		return model.flatMap { URL(string: $0.imageUrl) }
	}

	var raised: Double {
		return model.flatMap { $0.economics.raised.rounded() } ?? 0
	}

	var hardCap: Int {
		return model.flatMap { $0.economics.hardCap } ?? 0
	}

	var softCap: Int {
		return model.flatMap { $0.economics.softCap } ?? 0
	}

	var daysLeft: String {
		return model.flatMap { Date.presentRelative($0.endTimestamp) } ?? ""
	}
}
