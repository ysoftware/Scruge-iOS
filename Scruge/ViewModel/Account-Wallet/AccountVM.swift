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

	var name:String {
		return model?.name ?? ""
	}

	func balanceString(_ separator:String = "\n") -> NSAttributedString {
		let currencyAtt = AttributesBuilder()
			.color(Service.constants.color.purple)
			.font(.systemFont(ofSize: 18, weight: .semibold)).build()
		let balanceAtt = AttributesBuilder()
			.color(.black)
			.font(.systemFont(ofSize: 16, weight: .medium)).build()

		let att = NSMutableAttributedString()
		balances.forEach { balance in
			let amount = balance.amount.formatRounding(to: 4, min: 4)
			if att.length > 0 { att.append(separator) }
			att.append(balance.symbol, withAttributes: currencyAtt)
				.append("  ")
				.append(amount, withAttributes: balanceAtt)
		}
		return att
	}

	// MARK: - Methods

	func updateBalance() {
		Service.eos.getBalance(for: name, currencies: ["EOS", "SCR"]) { balances in
			self.balances = balances.sorted()
			self.notifyUpdated()
		}
	}
}
