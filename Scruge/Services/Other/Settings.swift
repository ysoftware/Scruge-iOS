//
//  Settings.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

/// Набор статических методов для работы с UserDefaults.
struct Settings {

	/// Очистить все настройки пользователя
	public func clear() {
		let domain = Bundle.main.bundleIdentifier!
		defaults.removePersistentDomain(forName: domain)
		defaults.synchronize()
	}

	private let defaults:UserDefaults = .standard

	enum Setting:String {

		case selectedAccount = "selectedAccount"

		case userTokens = "userTokens"

		case nodeUrl = "nodeUrl"
	}

	func get<T>(_ setting:Setting) -> T? {
		return defaults.object(forKey: setting.rawValue) as? T
	}

	func set(_ setting:Setting, value:Any?) {
		defaults.set(value, forKey: setting.rawValue)
	}

	func remove(_ setting:Setting) {
		defaults.removeObject(forKey: setting.rawValue)
	}
}
