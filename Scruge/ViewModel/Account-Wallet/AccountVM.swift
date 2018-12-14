//
//  AccountVM.swift
//  Scruge
//
//  Created by ysoftware on 19/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class AccountVM:ViewModel<AccountModel> {

	private var balances:[Balance] = []

	// MARK: - View Properties

	var name:String {
		return model?.name ?? ""
	}

	func balanceString(_ separator:String = "\n") -> String {
		return balances.reduce("") { result, balance in
			let amount = balance.amount.formatRounding(to: 4, min: 4)
			let separator =  result.count > 0 ? separator : ""
			return "\(result)\(separator)\(balance.symbol) \(amount)"
		}
	}

	// MARK: - Methods

	func updateBalance() {
		Service.eos.getBalance(for: name, currencies: ["EOS", "SCR"]) { balances in
			self.balances = balances.sorted()
			self.notifyUpdated()
		}
	}
}
