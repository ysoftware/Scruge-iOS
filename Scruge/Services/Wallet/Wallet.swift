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

	func getWallet() -> SELocalAccount? {
		return service.keystore.defaultAccount()
	}

	func deleteWallet() {
		guard let account = getWallet() else { return }
		try? service.deleteAccount(account: account)
	}

	func createKey(_ passcode:String,
				   _ completion: @escaping (SELocalAccount?)->Void) {

		deleteWallet()
		service.newAccount(passcode: passcode, succeed: { account in
			completion(account)
		}) { error in
			completion(nil)
		}
	}

	func importKey(_ privateKey:String,
				   passcode: String,
				   _ completion: @escaping (SELocalAccount?)->Void) {

		guard privateKey.starts(with: "5") else {
			return completion(nil)
		}

		service.importAccount(privateKey: privateKey, passcode: passcode, succeed: { account in
			completion(account)
		}) { error in
			completion(nil)
		}
	}
}

extension SEKeystoreService {

	func deleteAccount(account: SELocalAccount) throws {
		try FileManager.default.removeItem(at: keystore.keyUrl.appendingPathComponent(account.publicKey!))
		SELocalAccount.__account = nil
	}
}
