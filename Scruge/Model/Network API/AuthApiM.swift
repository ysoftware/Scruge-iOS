//
//  AuthResp.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Response

struct AuthResponse: Codable {

	let success:Bool

	let token:String?
}

// MARK: - Request

struct AuthRequest: Codable {

	let email:String

	let password:String
}

struct VerificationRequest: Codable {

	let token:String
}
