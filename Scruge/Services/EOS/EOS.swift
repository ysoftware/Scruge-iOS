//
//  EOS.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct EOS {

	fileprivate let rpc = EOSRPC.sharedInstance

	init() {
		EOSRPC.endpoint = "http://31.10.90.99:8888"
	}

	func chainInfo() {
		rpc.chainInfo { info, error in

		}
	}

	func getBalance() {
		rpc.getCurrencyBalance(account: "default",
							   symbol: "EOS",
							   code: "eosio.token") { number, error in

		}
	}

	func sendMoney() {

		let privateKey = try! PrivateKey(keyString: "5JsK462V1twPZHXW2iBPNoncRT8XBC7NwUHkKS1FDgZNCTGZNZV")!

		let transfer = Transfer()
		transfer.from = "default"
		transfer.to = "username"
		transfer.quantity = "1.0 EOS"
		transfer.memo = "help"

		Currency.transferCurrency(transfer: transfer,
								  code: "eosio.token",
								  privateKey: privateKey) { result, error in

									guard self.handleError(error) else {
										return
									}

									// we got a result
		}
	}

	func handleError(_ error: Error?) -> Bool {
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
