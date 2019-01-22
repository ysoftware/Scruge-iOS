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
				return "This action requires authentication. Please, sign in with your Scruge account."
			case .invalidEmail:
				return "Incorrectly formatted email"
			case .accountBlocked:
				return "This account was blocked"
			case .accountExists:
				return "User already exists"
			case .incorrectCredentials:
				return "Incorrect credentials"
			case .denied:
				return "Access is restricted"
			}
		}
		else if let networkError = error as? NetworkingError {
			switch networkError {
			case .connectionProblem:
				return "Unable to connect to the server"
			case .unknown:
				return "Unknown network error"
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
			case .unknown:
				return "Unexpected server error"
			case .emailSendError:
				return "Unable to send email"
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
			case .unknown:
				return "Unknown wallet error"
			}
		}
		else if let eosError = error as? EOSError {
			switch eosError {
			case .overdrawnBalance:
				return "Overdrawn balance"
			case .unknown:
				return "Unknown blockchain error"
			case .abiError:
				return "Incorrect transaction format"
			case .incorrectName:
				return "Incorrect name: it can only contain letters, numbers from 1 to 5 and a dot"
			case .incorrectToken:
				return "Incorrect token input"
			case .actionError:
				return "Server was unable to complete blockchain transaction, please try again"
			case .notSupported:
				return "EOS: Not supported"
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
		else if let generalError = error as? GeneralError {
			switch generalError {
			case .unknown: return "Unexpected error"
			}
		}
		return error.localizedDescription
	}

	static func error(from result:Int) -> Error? {
		switch result {
		case 0: return nil
			
		// common
		case 10: return AuthError.invalidToken
		case 11: return BackendError.invalidResourceId
		case 12: return BackendError.resourceNotFound
		case 13: return AuthError.userNotFound
		case 14: return AuthError.denied

		// auth
		case 101: return AuthError.incorrectEmailLength
		case 102: return AuthError.invalidEmail
		case 103: return AuthError.incorrectPasswordLength
		case 104: return AuthError.noToken
		case 105: return AuthError.accountExists
		case 106: return AuthError.incorrectCredentials
		case 107: return AuthError.accountBlocked
		case 108: return BackendError.emailSendError

		// eos
		case 505: return EOSError.actionError
		case 599: return EOSError.notSupported
		case 501, 503: return nil

		// special
		case 999: return BackendError.notImplemented

		default: return GeneralError.unknown
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
