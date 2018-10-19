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

	private var balance:(NSDecimalNumber, String)?

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
		guard let balance = balance else { return "..." }
		return "\(balance.0) \(balance.1)"
	}

	// MARK: - Methods

	func updateBalance() {
		Service.eos.getBalance(for: name) { balance, symbol in
			self.balance = (balance, symbol)
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
