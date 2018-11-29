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
		guard let wallet = getWallet() else {
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

	func getWallet() -> SELocalAccount? {
		return Service.wallet.getWallet()
	}

	func deleteWallet() {
		Service.wallet.deleteWallet()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
			self.reloadData()
		}
	}

	func exportPrivateKey(passcode:String, _ completion: (Result<String, AnyError>)->Void) {
		guard let wallet = getWallet() else { return completion(.failure(AnyError(WalletError.noKey))) }

		do {
			let key = try wallet.decrypt(passcode: passcode)
			completion(.success(key.rawPrivateKey()))
		}
		catch {
			completion(.failure(AnyError(error)))
		}
	}

	func getPublicKey(passcode:String, _ completion: (Result<String, AnyError>)->Void) {
		guard let wallet = getWallet() else { return completion(.failure(AnyError(WalletError.noKey))) }

		try? wallet.timedUnlock(passcode: passcode, timeout: 2)
		guard !wallet.isLocked(), let key = wallet.rawPublicKey else {
			return completion(.failure(AnyError(WalletError.incorrectPasscode)))
		}

		completion(.success(key))
	}

	func createAccount(withName accountName:String,
					   passcode:String,
					   _ completion: @escaping (Error?)->Void) {
		guard let wallet = getWallet() else { return completion(nil) }

		try? wallet.timedUnlock(passcode: passcode, timeout: 2)
		guard !wallet.isLocked(), let key = wallet.rawPublicKey else {
			return completion(WalletError.incorrectPasscode)
		}

		Service.api.createAccount(withName: accountName, publicKey: key) { result in
			switch result {
			case .success(let response):
				let error = ErrorHandler.error(from: response.result)
				completion(error)
			case .failure(let error):
				completion(error)
			}
		}
	}
}
