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

	enum Status {

		case loading, noKey, noAccounts, ready, error(Error)
	}

	var status:Status = .noAccounts

	override func fetchData(_ block: @escaping (Result<[AccountModel], AnyError>) -> Void) {
		guard let wallet = getWallet() else {
			self.status = .noKey
			return block(.success([]))
		}

		Service.eos.getAccounts(for: wallet) { result in
			switch result {
			case .failure(let error):
				self.status = .error(error)
				return block(.success([]))
			case .success(let accounts):
				self.status = accounts.isEmpty ? .noAccounts : .ready
				let accounts = accounts.map { AccountModel(name: $0, wallet: wallet) }.sorted()
				block(.success(accounts))
			}
		}
	}

	func getWallet() -> SELocalAccount? {
		return Service.wallet.getWallet()
	}

	func deleteWallet() {
		Service.wallet.deleteWallet()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
			self.reloadData()
		}
	}
}
