//
//  TechnicalAVM.swift
//  Scruge
//
//  Created by ysoftware on 25/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class TechnicalAVM: SimpleArrayViewModel<Technical, TechnicalVM> {

	init(_ economics:Economics) {
		super.init()

		var items:[Technical] = []

		items.append(Technical(name: "Total token supply",
							   value: economics.tokenSupply.format(as: .decimal, separateWith: " "),
							   description: "Total amount of tokens to be issued"))

		items.append(Technical(name: "Token public percent",
							   value: "\(economics.publicTokenPercent)%",
			description: "Percent of all issued tokens to be sold to public"))

		items.append(Technical(name: "Initial release after successful funding",
							   value: "\(economics.initialFundsReleasePercent)%",
			description: "Percent of collected funds released to creators of the campaign immediately after successful funding"))

		if let inflation = economics.annualInflationPercent {
			let value = inflation.start != inflation.end
				? "\(inflation.start)% - \(inflation.end)%"
				: "\(inflation.start)%"

			items.append(Technical(name: "Annual inflation rate", value: value,
								   description: "Range of annual inflation rate"))
		}

		setData(items.map { TechnicalVM($0) })
	}

	override func fetchData(_ block: @escaping (Result<[Technical], AnyError>) -> Void) {
		// no-op
	}
}
