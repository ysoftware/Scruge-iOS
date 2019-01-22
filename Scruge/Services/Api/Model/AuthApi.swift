//
//  AuthApi.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import FirebaseMessaging

// MARK: - Response

struct LoginResponse: Codable {

	let token:String
}

struct UserIdResponse: Codable {

	let userId:Int
}

struct ProfileResponse: Codable {

	let profile:Profile
}

// MARK: - Request

struct EmailRequest: Codable {

	let email:String
}

struct LoginRequest: Codable {

	let login:String 
}

struct AuthRequest: Codable {

	init(login:String, password:String) {
		self.login = login
		self.password = password
	}

	let login:String

	let password:String

	let device = "iOS \(UIDevice.current.systemVersion)"

	let pushNotificationToken = Messaging.messaging().fcmToken
}

struct ProfileRequest: Codable {

	let name:String

	let country:String

	let description:String
}
