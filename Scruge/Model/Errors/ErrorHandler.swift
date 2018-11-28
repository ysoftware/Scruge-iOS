//
//  ErrorApi.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation
import Result

struct ErrorHandler {

	// extract Error from Result's AnyError
	private static func extractError(_ error:Error) -> Error {
		return (error as? AnyError)?.error ?? error
	}

	static func message(for error:Error) -> String {
		let error = extractError(error)
		if let authError = error as? AuthError {
			switch authError {
			case .incorrectEmailLength:
				return "Email should be longer than 5 and shorter than 254 symbols."
			case .incorrectPasswordLength:
				return "Password should be longer than 5 and shorter than 50 symbols."
			case .noToken, .invalidToken, .userNotFound:
				return "Authentication failed. Please try signing in again."
			case .invalidEmail:
				return "Incorrectly formatted email"
			case .accountBlocked:
				return "This account was blocked"
			case .accountExists:
				return "User already exists"
			case .incorrectCredentials:
				return "Incorrect credentials"
			}
		}
		else if let networkError = error as? NetworkingError {
			switch networkError {
			case .connectionProblem:
				return "Unable to connect to the server"
			case .unknown:
				return "Unknown error"
			}
		}
		else if let backendError = error as? BackendError {
			switch backendError {
			case .notImplemented:
				return "Not implemented"
			case .invalidResourceId:
				return "Malformed request"
			case .resourceNotFound:
				return "Nothing was found for this request"
			case .parsingError:
				return "Unexpected server response"
			}
		}
		else if let walletError = error as? WalletError {
			switch walletError {
			case .incorrectPasscode:
				return "Incorrect passcode"
			case .noAccounts:
				return "No accounts are associated with imported public key"
			case .noKey:
				return "You have no keys in your wallet"
			case .noSelectedAccount:
				return "You did not verify any EOS accounts"
			case .selectedAccountMissing:
				return "Your verified account is not accessible with imported EOS key"
			}
		}
		else if let eosError = error as? EOSError {
			switch eosError {
			case .overdrawnBalance:
				return "Overdrawn balance"
			case .unknown:
				return "Unknown error"
			case .abiError:
				return "Incorrect transaction format"
			}
		}
		else if (error as NSError).domain == "SwiftyEOSErrorDomain" {
			if let response = (error as NSError).userInfo["RPCErrorResponse"] as? RPCErrorResponse {
				return response.error.details.reduce("") { $0 + "\n" + $1.message }
					.replacingOccurrences(of: "assertion failure with message:", with: "")
					.replacingOccurrences(of: "pending console output:", with: "")
					.trimmingCharacters(in: .whitespacesAndNewlines)
			}
		}
		return "Unexpected Error"
	}

	static func error(from result:Int) -> Error? {
		switch result {
		case 0: return nil
			
		// common
		case 10: return AuthError.invalidToken
		case 11: return BackendError.invalidResourceId
		case 12: return BackendError.resourceNotFound
		case 13: return AuthError.userNotFound

		// auth
		case 101: return AuthError.incorrectEmailLength
		case 102: return AuthError.invalidEmail
		case 103: return AuthError.incorrectPasswordLength
		case 104: return AuthError.noToken
		case 105: return AuthError.accountExists
		case 106: return AuthError.incorrectCredentials
		case 107: return AuthError.accountBlocked

		// special
		case 999: return BackendError.notImplemented

		default: return NetworkingError.unknown
		}
	}
}

extension Error {

	var isAuthenticationFailureError: Bool {
		if let error = self as? AuthError {
			switch error {
			case .userNotFound, .invalidToken, .noToken: return true
			default: break
			}
		}
		return false
	}
}
