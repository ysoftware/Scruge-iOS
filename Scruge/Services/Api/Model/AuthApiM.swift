//
//  AuthResp.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

// MARK: - Response

struct ResultResponse: Codable {

	let result:Int
}

struct LoginResponse: Codable {

	let result:Int

	let token:String?
}

struct ProfileResponse: Codable {

	let result:Int

	let profile:Profile?
}

// MARK: - Request

struct EmailRequest: Codable {

	let email:String
}

struct AuthRequest: Codable {

	init(login:String, password:String) {
		self.login = login
		self.password = password
	}

	let login:String

	let password:String

	let device = "iOS \(UIDevice.current.systemVersion)"
}

struct ProfileRequest: Codable {

	let name:String

	let country:String

	let description:String
}
