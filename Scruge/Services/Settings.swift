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

	private init() {}

	/// Очистить все настройки пользователя
	public static func clear() {
		let domain = Bundle.main.bundleIdentifier!
		defaults.removePersistentDomain(forName: domain)
		defaults.synchronize()
	}

	private static let defaults:UserDefaults = .standard
}
