//
//  PartialCampVM.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

protocol PartialCampaignProperties {

	var description:String { get }

	var title:String { get }

	var progress:Double { get }

	var raisedString:String { get }

	var daysLeft:String { get }
}


final class PartialCampaignVM: ViewModel<PartialCampaign>, PartialCampaignProperties {

	var id:String {
		return model?.id ?? ""
	}

	var imageUrl:String {
		return model?.imageUrl ?? ""
	}

	var description:String {
		return model?.description ?? ""
	}

	var title:String {
		return model?.title ?? ""
	}

	var progress:Double {
		guard let model = model else { return 0 }
		return model.raisedAmount / model.fundAmount
	}

	var raisedString:String {
		guard let model = model else { return "" }
		return "$\(model.raisedAmount) raised of $\(model.fundAmount)"
	}

	var daysLeft:String {
		return "n days left"
	}
}
