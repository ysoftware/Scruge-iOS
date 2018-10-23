//
//  AccountVM.swift
//  Scruge
//
//  Created by ysoftware on 19/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class AccountVM:ViewModel<AccountModel> {

	let UNLOCK_DURATION:TimeInterval = 180

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
		return balances.reduce("", { result, balance in
			let separator =  result.count > 0 ? ", " : ""
			return "\(result)\(separator)\(balance.amount) \(balance.symbol)"
		})
	}

	// MARK: - Methods

	func updateBalance() {
		Service.eos.getBalance(for: name, currencies: ["EOS", "SCR"]) { balances in
			self.balances = balances
			self.notifyUpdated()
		}
	}

	/// unlocks the wallet for 3 minutes
	func unlock(_ passcode:String) -> Bool {
		do {
			try model!.wallet.timedUnlock(passcode: passcode, timeout: UNLOCK_DURATION)
			return true
		}
		catch {
			return false
		}
	}
}
