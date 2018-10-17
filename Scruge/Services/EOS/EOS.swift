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

		let privateKey = PrivateKey.randomPrivateKey()! //(keyString: "5JsK462V1twPZHXW2iBPNoncRT8XBC7NwUHkKS1FDgZNCTGZNZV")!
		let publicKey = PublicKey(privateKey: privateKey)

		print("private key: \(privateKey.wif())")
		print("public key : \(publicKey.wif())")

		let transfer = Transfer()
		transfer.from = "default"
		transfer.to = "username"
		transfer.quantity = "1.0 EOS"
		transfer.memo = "test"

		Currency.transferCurrency(transfer: transfer,
								  code: "eosio.token",
								  privateKey: privateKey) { result, error in

		}
	}
}
