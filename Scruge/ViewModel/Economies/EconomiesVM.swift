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
		return model?.tokenSupply.format(as: .decimal, separateWith: " ") ?? ""
	}

	var publicPercent:String {
		return model.flatMap { "\($0.publicTokenPercent.format(as: .decimal))%" } ?? ""
	}

	var initialRelease:String {
		return model.flatMap { "\($0.initialFundsReleasePercent.format(as: .decimal))%" } ?? ""
	}

	var inflationRate:String {
		guard let model = model else { return "" }
		let start = model.annualInflationPercent.start.format(as: .decimal)
		let end = model.annualInflationPercent.end.format(as: .decimal)
		return model.annualInflationPercent.start != model.annualInflationPercent.end
			? "\(start)% - \(end)%"
			: "\(start)%"
	}
}
