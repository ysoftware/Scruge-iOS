//
//  EOS.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct EOS {

	fileprivate let chain = EOSRPC.sharedInstance

	init() {
		EOSRPC.endpoint = "http://31.10.90.99:8888"
	}

	// MARK: - Methods

	func getAccounts(for wallet:SELocalAccount, completion: @escaping ([String])->Void) {
		guard let key = wallet.rawPublicKey else {
			return completion([])
		}

		chain.getKeyAccounts(pub: key) { result, error in
			guard self.handleError(error) else {
				return
			}

			completion(result!.accountNames)
		}
	}

	/// send money from this account
	/// wallet has to be unlocked first
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
									 unlockOncePasscode: nil) { result, error in
										guard self.handleError(error) else {
											return completion(false)
										}
										print("Transaction id: \(result!.transactionId)")
										completion(true)
		}
	}

	func getBalance(for account:String, _ completion: @escaping (NSDecimalNumber, String)->Void) {
		let symbol = "EOS"
		chain.getCurrencyBalance(account: account, symbol: symbol, code: "eosio.token") { number, error in
			guard self.handleError(error) else {
				return completion(0, symbol)
			}
			completion(number!, symbol)
		}
	}

	// MARK: - Handle

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
