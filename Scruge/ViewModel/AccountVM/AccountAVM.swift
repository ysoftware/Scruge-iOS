//
//  AccountAVM.swift
//  Scruge
//
//  Created by ysoftware on 19/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class AccountAVM:SimpleArrayViewModel<AccountModel, AccountVM> {

	var passcode:String

	init(passcode:String) {
		self.passcode = passcode
	}

	override func fetchData(_ block: @escaping (Result<[AccountModel], AnyError>) -> Void) {
		var i = 0
		var out:[AccountModel] = []
		let wallets = Service.wallet.getWallets(passcode)

		for wallet in wallets {
			Service.eos.getAccounts(for: wallet) { accounts in
				out.append(contentsOf: accounts.map { AccountModel(name: $0, wallet: wallet) })

				i += 1
				if i == wallets.count {
					block(.success(out))
					self.reloadBalance()
				}
			}
		}
	}

	private func reloadBalance() {
		for element in array {
			element.updateBalance()
		}
	}
}
