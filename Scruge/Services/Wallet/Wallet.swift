//
//  Wallet.swift
//  Scruge
//
//  Created by ysoftware on 05/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Wallet {

	fileprivate let service = SEKeystoreService.sharedInstance

	func getWallets() -> [SELocalAccount] {
		return service.keystore.accounts()
	}

	func createKey(_ passcode:String,
				   _ completion: @escaping (SELocalAccount?)->Void) {

		service.newAccount(passcode: passcode, succeed: { account in
			completion(account)
		}) { error in
			completion(nil)
		}
	}

	func importKey(_ privateKey:String,
				   passcode: String,
				   _ completion: @escaping (SELocalAccount?)->Void) {

		service.importAccount(privateKey: privateKey, passcode: passcode, succeed: { account in
			completion(account)
		}) { error in
			completion(nil)
		}
	}
}
