//
//  OtherApiM.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Response

// MARK: - Request

struct TokenRequest: Codable {

	let token = Service.tokenManager.getToken()
}