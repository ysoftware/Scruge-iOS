//
//  Services.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct Service {

	private init() { }

	static let api = Api()

	static let tokenManager = TokenManager()

	static let settings = Settings()

	static let constants = Constants()

	static let eos = EOS()

	static let wallet = Wallet()
}
