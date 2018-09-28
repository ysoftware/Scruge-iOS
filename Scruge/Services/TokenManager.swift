//
//  TokenManager.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import KeychainSwift

final class TokenManager {

	private let AUTH_TOKEN = "auth_token"

	private let keychain = KeychainSwift()

	init() {
		keychain.synchronizable = false
	}

	func save(_ token:String) {
		keychain.set(token, forKey: AUTH_TOKEN, withAccess: .accessibleWhenUnlockedThisDeviceOnly)
	}

	func removeToken() {
		keychain.delete(AUTH_TOKEN)
	}

	func getToken() -> String? {
		return keychain.get(AUTH_TOKEN)
	}
}
