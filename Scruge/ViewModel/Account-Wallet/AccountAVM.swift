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

	override func fetchData(_ block: @escaping (Result<[AccountModel], AnyError>) -> Void) {
		guard let wallet = Service.wallet.getWallet() else {
			return block(.failure(AnyError(WalletError.noKey)))
		}

		Service.eos.getAccounts(for: wallet) { result in
			switch result {
			case .failure(let error):
				return block(.failure(AnyError(error)))
			case .success(let accounts):
				if !accounts.isEmpty {
					let accounts = accounts.map { AccountModel(name: $0, wallet: wallet) }.sorted()
					block(.success(accounts))
				}
				else {
					block(.failure(AnyError(WalletError.noAccounts)))
				}
			}
		}
	}

	// MARK: - Methods

	var selectedAccount:AccountVM? {
		guard let selectedAccount:String = Service.settings.get(.selectedAccount)
			else { return nil }
		return array.first(where: { $0.name == selectedAccount })
	}

	func deleteWallet() {
		Service.wallet.deleteWallet()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
			self.reloadData()
		}
	}
}
