//
//  ProjectVM.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM

final class ProjectVM: ViewModel<Project> {

	var providerName:String {
		return model?.providerName ?? ""
	}

	var name:String {
		return model?.projectName ?? ""
	}

	var imageUrl:String? {
		return model?.imageUrl
	}

	var videoUrl:String? {
		return model?.videoUrl
	}

	var description:String {
		return model?.projectDescription ?? ""
	}

	var social:[Social] {
		return model?.social ?? []
	}

	var documents:[Document] {
		return model?.documents ?? []
	}

	var tokenSupply:String {
		return model?.economics.tokenSupply.formatDecimal(separateWith: " ") ?? ""
	}

	var inflation:String {
		guard let model = model?.economics else { return "" }
		let start = model.annualInflationPercent.start.formatDecimal()
		let end = model.annualInflationPercent.end.formatDecimal()
		return model.annualInflationPercent.start != model.annualInflationPercent.end
			? "\(start)% - \(end)%"
			: "\(start)%"
	}

	var tokenListingDate:String? {
		return model?.economics.listingTimestamp.flatMap { Date.present($0, as: "MMMM yyyy") }
	}

	var tokenExchange:String? {
		return model?.economics.exchange?.name
	}

	var tokenUrl:String? {
		return model?.economics.exchange?.url
	}
}
