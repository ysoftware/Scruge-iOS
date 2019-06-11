//
//  AccountAVM.swift
//  Scruge
//
//  Created by ysoftware on 19/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM


final class AccountAVM:SimpleArrayViewModel<AccountModel, AccountVM> {

	override func fetchData(_ block: @escaping (Result<[AccountModel], Error>) -> Void) {
		guard let wallet = Service.wallet.getWallet() else {
			return block(.failure(WalletError.noKey))
		}

		Service.eos.getAccounts(for: wallet) { result in
			block(result.flatMap { accounts in
				if !accounts.isEmpty {
					let models = accounts.map { AccountModel(name: $0, wallet: wallet) }.sorted()
					return .success(models)
				}
				else {
					return .failure(WalletError.noAccounts)
				}
			})
		}
	}

	// MARK: - Methods

	var selectedAccount:AccountVM? {
		guard let selectedAccount:String = Service.settings.get(.selectedAccount)
			else { return nil }
		return array.first(where: { $0.displayName == selectedAccount })
	}

	func deleteWallet() {
		Service.wallet.deleteWallet()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
			self.reloadData()
		}
	}
}
