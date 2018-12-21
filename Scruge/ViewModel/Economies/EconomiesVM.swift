//
//  TechnicalVM.swift
//  Scruge
//
//  Created by ysoftware on 25/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class EconomiesVM: ViewModel<Economics> {

	var tokenSupply:String {
		return model?.tokenSupply.formatDecimal(separateWith: " ") ?? ""
	}

	var publicPercent:String {
		return model.flatMap { "\($0.publicTokenPercent.formatDecimal())%" } ?? ""
	}

	var initialRelease:String {
		return model.flatMap { "\($0.initialFundsReleasePercent.formatDecimal())%" } ?? ""
	}

	var inflationRate:String {
		guard let model = model else { return "" }
		let start = model.annualInflationPercent.start.formatDecimal()
		let end = model.annualInflationPercent.end.formatDecimal()
		return model.annualInflationPercent.start != model.annualInflationPercent.end
			? "\(start)% - \(end)%"
			: "\(start)%"
	}
}
