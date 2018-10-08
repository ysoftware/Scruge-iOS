//
//  ErrorApi.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation
import Result

enum AuthError: Error {

	case blocked

	case exists

	case incorrectCredentials
}

enum NetworkingError: Error {

	case connectionProblem

	case unknown

	case parsingError
}

struct ErrorHandler {

	// extract Error from Result's AnyError
	private static func extractError(_ error:Error) -> Error {
		return (error as? AnyError)?.error ?? error
	}

	static func message(for error:Error) -> String {
		let error = extractError(error)
		if let authError = error as? AuthError {
			switch authError {
			case .blocked: return "This account was blocked"
			case .exists: return "User already exists"
			case .incorrectCredentials: return "Incorrect credentials"
			}
		}
		else if let networkError = error as? NetworkingError {
			switch networkError {
			case .parsingError: return "Unexpected server response"
			case .connectionProblem: return "Unable to connect to the server"
			case .unknown: break
			}
		}
		return "Unexpected Error"
	}

	static func error(from result:Int) -> Error? {
		switch result {
		case 0: return nil
		case 1001: return AuthError.exists
		case 1002: return AuthError.incorrectCredentials
		case 1003: return AuthError.blocked
		default: return NetworkingError.unknown
		}
	}
}
