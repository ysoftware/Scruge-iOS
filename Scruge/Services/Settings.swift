//
//  Settings.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Набор статических методов для работы с UserDefaults.
final class Settings {

	/// Очистить все настройки пользователя
	public func clear() {
		let domain = Bundle.main.bundleIdentifier!
		defaults.removePersistentDomain(forName: domain)
		defaults.synchronize()
	}

	private let defaults:UserDefaults = .standard

	// MARK: - Auth

	let USER_ID = "user_id"

	var userId:String? {
		return defaults.string(forKey: USER_ID)
	}

	func setUserId(_ id:String) {
		defaults.set(id, forKey: USER_ID)
	}
}
