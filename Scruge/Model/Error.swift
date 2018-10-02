//
//  ErrorApi.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

enum AuthError: Error {

	case exists

	case incorrectCredentials

	static func from(_ error:Error?) -> AuthError {
		// TO-DO: actually parse
		return .exists
	}
}

enum NetworkingError: Error {

	case connectionProblem

	case unknown

	case parsingError
}

func makeError(_ error:Error) -> String {
	let m:String
	switch error {
	case AuthError.exists: m = "User already exists"
	case AuthError.incorrectCredentials: m = "Incorrect credentials"
	case NetworkingError.parsingError: m = "Incorrect server response"
	case NetworkingError.connectionProblem: m = "Connection problem"
	default: m = "An error occured"
	}
	return m
}
