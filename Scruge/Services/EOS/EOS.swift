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
			guard let accountNames = result?.accountNames else {
				return completion(.failure(AnyError(error ?? EOSError.unknown)))
			}

			completion(.success(accountNames))
		}
	}

	/// send money from this account
	func sendMoney(from account:AccountModel,
				   to recipient:String,
				   amount:Double,
				   symbol:String,
				   memo:String = "",
				   passcode:String,
				   _ completion: @escaping (Result<String, AnyError>)->Void) {

		let quantity = "\(amount.formatRounding(to: 4, min: 4)) \(symbol)"
			.replacingOccurrences(of: ",", with: ".")
		let transfer = Transfer()
		transfer.from = account.name
		transfer.to = recipient
		transfer.quantity = quantity
		transfer.memo = memo

		account.wallet.transferToken(transfer: transfer,
									 code: "eosio.token",
									 unlockOncePasscode: passcode) { result, error in
										guard let transactionId = result?.transactionId else {
											return completion(.failure(AnyError(error ?? EOSError.unknown)))
										}
										return completion(.success(transactionId))
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

										i += 1
										balances.append(Balance(symbol: currency,
																amount: number ?? 0))

										if i == currencies.count {
											completion(balances)
										}
			}
		}
	}
}
