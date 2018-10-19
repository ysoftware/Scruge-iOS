//
//  AccountVM.swift
//  Scruge
//
//  Created by ysoftware on 19/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class AccountVM:ViewModel<AccountModel> {

	required init(_ model: AccountModel, arrayDelegate: ViewModelDelegate?) {
		super.init(model, arrayDelegate: arrayDelegate)
		updateBalance()
	}

	var name:String {
		return model!.name
	}

	private var balance:(NSDecimalNumber, String)?

	var balanceString:String {
		guard let balance = balance else { return "..." }
		return "\(balance.0) \(balance.1)"
	}

	func updateBalance() {
		Service.eos.getBalance(for: name) { balance, symbol in
			self.balance = (balance, symbol)
			self.notifyUpdated()
		}
	}
}
