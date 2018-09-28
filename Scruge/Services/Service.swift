//
//  Services.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

final class Service {

	private init() { }

	static let api:Api = .init()

	static let tokenManager = TokenManager()

	static let settings = Settings()
}
