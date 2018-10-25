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
