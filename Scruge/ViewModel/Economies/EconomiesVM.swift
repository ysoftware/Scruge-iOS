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
		guard let publicToken = model?.publicTokenPercent.format(as: .decimal)
			else { return "" }
		return "\(publicToken)%"
	}

	var initialRelease:String {
		guard let initialRelease = model?.initialFundsReleasePercent.format(as: .decimal)
			else { return "" }
		return "\(initialRelease)%"
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
