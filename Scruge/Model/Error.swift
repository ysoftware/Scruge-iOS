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

	case accountBlocked // user_banned

	case accountExists // login_already_exists

	case incorrectCredentials // login_or_pass_not_valid

	case invalidEmail // invalid_email_format

	case authenticationFailed // token_must_not_be_empty

	case incorrectEmailLength // login_must_be_5_254_symbols

	case incorrectPasswordLength // password_must_be_5_50_symbols
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
			case .incorrectEmailLength: return "Email should be longer than 5 and shorter than 254 symbols."
			case .incorrectPasswordLength: return "Password should be longer than 5 and shorter than 50 symbols."
			case .authenticationFailed: return "Authentication failed. Please try logging out and back in again."
			case .invalidEmail: return "Incorrectly formatted email"
			case .accountBlocked: return "This account was blocked"
			case .accountExists: return "User already exists"
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
		case 101: return AuthError.incorrectEmailLength
		case 102: return AuthError.invalidEmail
		case 103: return AuthError.incorrectPasswordLength
		case 104: return AuthError.authenticationFailed
		case 201: return AuthError.accountExists
		case 301: return AuthError.incorrectCredentials
		case 310: return AuthError.accountBlocked
		default: return NetworkingError.unknown
		}
	}
}
