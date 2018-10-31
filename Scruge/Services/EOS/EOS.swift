//
//  EOS.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Result

struct EOS {

	fileprivate let chain = EOSRPC.sharedInstance

	init() {
		EOSRPC.endpoint = "http://35.242.241.205:7777"
	}

	// MARK: - Methods

	func getAccounts(for wallet:SELocalAccount,
					 completion: @escaping (Result<[String], AnyError>)->Void) {

		guard let key = wallet.rawPublicKey else {
			return completion(.failure(AnyError(WalletError.noKey)))
		}

		chain.getKeyAccounts(pub: key) { result, error in
			guard self.handleError(error) else {
				return completion(.failure(AnyError(error!)))
			}

			completion(.success(result!.accountNames))
		}
	}

	/// send money from this account
	func sendMoney(from account:AccountModel,
				   to recipient:String,
				   amount:NSDecimalNumber,
				   symbol:String,
				   passcode:String,
				   _ completion: @escaping (Bool)->Void) {

		let transfer = Transfer()
		transfer.from = account.name
		transfer.to = recipient
		transfer.quantity = "\(amount) \(symbol)"
		transfer.memo = ""

		account.wallet.transferToken(transfer: transfer,
									 code: "eosio.token",
									 unlockOncePasscode: passcode) { result, error in
										guard self.handleError(error) else {
											return completion(false)
										}
										print("Transaction id: \(result!.transactionId)")
										completion(true)
		}
	}

	func getBalance(for account:String,
					currencies:[String],
					_ completion: @escaping ([Balance])->Void) {

		var i = 0
		var balances:[Balance] = []

		for currency in currencies {
			chain.getCurrencyBalance(account: account,
									 symbol: currency,
									 code: "eosio.token") { number, error in
										self.handleError(error)

										i += 1
										balances.append(Balance(symbol: currency,
																amount: number ?? 0))

										if i == currencies.count {
											completion(balances)
										}
			}
		}
	}

	// MARK: - Handle

	@discardableResult
	private func handleError(_ error: Error?) -> Bool {
		if let error = error as NSError? {
			if let error = (error.userInfo["RPCErrorResponse"] as? RPCErrorResponse)?.error {
				print("EOS Response: \(error.name) (\(error.code)):\n\(error.what)")
				if !error.details.isEmpty {
					print(error.details)
				}
			}
			else {
				print("EOS Response: \(error)")
			}
			return false
		}
		return true
	}
}
