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

	case accountBlocked

	case accountExists

	case incorrectCredentials

	case invalidEmail

	case authenticationFailed // passed empty token

	case incorrectEmailLength // 5 to 254 symbols

	case incorrectPasswordLength // 5 to 50 symbols
}

enum BackendError: Error {

	case parsingError

	case resourceNotFound

	case badRequest
}

enum NetworkingError: Error {

	case connectionProblem

	case unknown(Int)
}

enum WalletError: Error {

	case noAccounts

	case noKey
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
			case .authenticationFailed: return "Bad request"//"Authentication failed. Please try logging out and back in again." // TO-DO: replace it back
			case .invalidEmail: return "Incorrectly formatted email"
			case .accountBlocked: return "This account was blocked"
			case .accountExists: return "User already exists"
			case .incorrectCredentials: return "Incorrect credentials"
			}
		}
		else if let networkError = error as? NetworkingError {
			switch networkError {
			case .connectionProblem: return "Unable to connect to the server"
			case .unknown(let code): return "Error: \(code)"
			}
		}
		else if let backendError = error as? BackendError {
			switch backendError {
			case .badRequest: return "Malformed request"
			case .resourceNotFound: return "Nothing was found for this request"
			case .parsingError: return "Unexpected server response"
			}
		}
		return "Unexpected Error"
	}

	static func error(from result:Int) -> Error? {
		switch result {
		case 0: return nil
			
		// common
		case 10: return AuthError.authenticationFailed
		case 11: return BackendError.badRequest
		case 12: return BackendError.resourceNotFound
		// auth
		case 101: return AuthError.incorrectEmailLength
		case 102: return AuthError.invalidEmail
		case 103: return AuthError.incorrectPasswordLength
		case 104: return AuthError.authenticationFailed
		case 105: return AuthError.accountExists
		case 106: return AuthError.incorrectCredentials
		case 107: return AuthError.accountBlocked

		default: return NetworkingError.unknown(result)
		}
	}
}
