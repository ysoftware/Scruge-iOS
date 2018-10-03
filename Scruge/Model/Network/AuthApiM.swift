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

	let result:Int
}

struct LoginResponse: Codable {

	let result:Int

	let token:String?
}

struct ProfileResponse: Codable {

	let user:Profile?
}

// MARK: - Request

struct EmailRequest: Codable {

	let email:String
}

struct AuthRequest: Codable {

	let email:String

	let password:String
}
