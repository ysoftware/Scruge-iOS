//
//  AccountVM.swift
//  Scruge
//
//  Created by ysoftware on 19/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class AccountVM:ViewModel<AccountModel> {

	let UNLOCK_DURATION:TimeInterval = 30

	private var balances:[Balance] = []

	required init(_ model: AccountModel, arrayDelegate: ViewModelDelegate?) {
		super.init(model, arrayDelegate: arrayDelegate)
		updateBalance()
	}

	// MARK: - View Properties

	var name:String {
		return model!.name
	}

	var isLocked:Bool {
		return model!.wallet.isLocked()
	}

	var balanceString:String {
		return balances.reduce("") { result, balance in
			let amount = balance.amount.doubleValue.formatRounding(to: 4, min: 4)
			let separator =  result.count > 0 ? "\n" : ""
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
