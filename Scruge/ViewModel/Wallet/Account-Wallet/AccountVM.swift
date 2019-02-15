//
//  AccountVM.swift
//  Scruge
//
//  Created by ysoftware on 19/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import appendAttributedString

final class AccountVM:ViewModel<AccountModel> {

	private var balances:[Balance] = []

	// MARK: - View Properties

	var name:EosName? {
		return model?.name.eosName
	}

	var displayName:String {
		return name?.string ?? ""
	}

	func balanceString(_ separator:String = "\n") -> NSAttributedString {
		let currencyAtt = AttributesBuilder()
			.color(Service.constants.color.purple)
			.font(.systemFont(ofSize: 18, weight: .semibold)).build()

		let balanceAtt = AttributesBuilder()
			.color(Service.constants.color.grayTitle)
			.font(.systemFont(ofSize: 16, weight: .medium)).build()

		let fiatAtt = AttributesBuilder()
			.color(Service.constants.color.gray)
			.font(.systemFont(ofSize: 15, weight: .semibold)).build()

		let att = NSMutableAttributedString()
		balances.forEach { balance in
			let amount = balance.amount.formatRounding(to: 4, min: 4)

			if att.length > 0 { att.append(separator) }
			att.append(balance.token.symbol, withAttributes: currencyAtt)
				.append("  ")
				.append(amount, withAttributes: balanceAtt)

			if let symbol = Asset(rawValue: balance.token.symbol),
				let usd = Service.exchangeRates.convert(Quantity(balance.amount, symbol),
														to: .usd) {
				let usdString = usd.amount.formatRounding(to: 2)
				att.append("  ")
					.append("($\(usdString))", withAttributes: fiatAtt)
			}
		}
		return att
	}

	// MARK: - Methods

	func updateBalance() {
		guard let name = name else { return }
		Service.eos.getBalance(for: name, tokens: Token.default) { balances in
			self.balances = balances.sorted()
			self.notifyUpdated()
		}
	}
}
