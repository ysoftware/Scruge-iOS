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
				return R.string.localizable.error_auth_incorrectEmailLength()
			case .incorrectPasswordLength:
				return R.string.localizable.error_auth_incorrectPasswordLength()
			case .noToken, .invalidToken, .userNotFound:
				return R.string.localizable.error_auth_notAuthorized()
			case .invalidEmail:
				return R.string.localizable.error_auth_invalidEmail()
			case .accountBlocked:
				return R.string.localizable.error_auth_accountBlocked()
			case .accountExists:
				return R.string.localizable.error_auth_accountExists()
			case .incorrectCredentials:
				return R.string.localizable.error_auth_incorrectCredentials()
			case .denied:
				return R.string.localizable.error_auth_denied()
			case .emailNotConfirmed:
				return R.string.localizable.error_auth_email_not_confirmed()
			}
		}
		else if let networkError = error as? NetworkingError {
			switch networkError {
			case .connectionProblem:
				return R.string.localizable.error_network_connectionProblem()
			case .unknown:
				return R.string.localizable.error_network_unknown()
			}
		}
		else if let backendError = error as? BackendError {
			switch backendError {
			case .notImplemented:
				return R.string.localizable.error_backend_notImplemented()
			case .invalidResourceId:
				return R.string.localizable.error_backend_invalidResourceId()
			case .resourceNotFound:
				return R.string.localizable.error_backend_resourceNotFound()
			case .parsingError:
				return R.string.localizable.error_backend_parsingError()
			case .unknown:
				return R.string.localizable.error_backend_unknown()
			case .emailSendError:
				return R.string.localizable.error_backend_emailSendError()
			case .paramsConflict:
				return R.string.localizable.error_backend_paramsConflict()
			case .replyNotSupported:
				return R.string.localizable.error_backend_replyNotSupported()
			}
		}
		else if let walletError = error as? WalletError {
			switch walletError {
			case .incorrectPasscode:
				return R.string.localizable.error_wallet_incorrectPasscode()
			case .noAccounts:
				return R.string.localizable.error_wallet_noAccounts()
			case .noKey:
				return R.string.localizable.error_wallet_noKey()
			case .noSelectedAccount:
				return R.string.localizable.error_wallet_noSelectedAccount()
			case .selectedAccountMissing:
				return R.string.localizable.error_wallet_selectedAccountMissing()
			case .unknown:
				return R.string.localizable.error_wallet_unknown()
			}
		}
		else if let eosError = error as? EOSError {
			switch eosError {
			case .overdrawnBalance:
				return R.string.localizable.error_eos_overdrawnBalance()
			case .unknown:
				return R.string.localizable.error_eos_unknown()
			case .abiError:
				return R.string.localizable.error_eos_abiError()
			case .incorrectName:
				return R.string.localizable.error_eos_incorrectName()
			case .incorrectToken:
				return R.string.localizable.error_eos_incorrectToken()
			case .actionError:
				return R.string.localizable.error_eos_actionError()
			case .notSupported:
				return R.string.localizable.error_eos_notSupported()
			case .eosAccountExists:
				return R.string.localizable.error_eos_eosAccountExists()
			case .createAccountIpLimitReached:
				return R.string.localizable.error_eos_createAccountIpLimitReached()
			case .createAccountDailyLimitReached:
				return R.string.localizable.error_eos_createAccountDailyLimitReached()
			}
		}
		else if (error as NSError).domain == "SwiftyEOSErrorDomain" {
			if let response = (error as NSError).userInfo["RPCErrorResponse"] as? RPCErrorResponse {
				let msg = response.error.details.reduce("") { $0 + "\n" + $1.message }
					.replacingOccurrences(of: "assertion failure with message:", with: "")
					.replacingOccurrences(of: "pending console output:", with: "")
					.trimmingCharacters(in: .whitespacesAndNewlines)
				let message = msg.isBlank ? ErrorHandler.message(for: EOSError.unknown) : msg
				return R.string.localizable.error_eos_transaction_failed(message)
			}
		}
		else if let generalError = error as? GeneralError {
			switch generalError {
			case .unknown(let code):
				return R.string.localizable.error_general_code("\(code)")
			case .implementationError:
				return R.string.localizable.error_general_unexpected()
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
		case 15: return BackendError.paramsConflict
		case 16: return BackendError.replyNotSupported

		// auth
		case 101: return AuthError.incorrectEmailLength
		case 102: return AuthError.invalidEmail
		case 103: return AuthError.incorrectPasswordLength
		case 104: return AuthError.noToken
		case 105: return AuthError.accountExists
		case 106: return AuthError.incorrectCredentials
		case 107: return AuthError.accountBlocked
		case 108: return BackendError.emailSendError
		case 109: return AuthError.emailNotConfirmed

		// eos
		case 501: return EOSError.incorrectName
		case 502: return EOSError.eosAccountExists
		case 505: return EOSError.actionError
		case 506: return EOSError.createAccountIpLimitReached
		case 507: return EOSError.createAccountDailyLimitReached

		case 599: return EOSError.notSupported

		// html
		case 400: return BackendError.paramsConflict
		case 404: return BackendError.resourceNotFound
		case 500: return BackendError.unknown

		// special
		case 999: return BackendError.notImplemented

		default: return GeneralError.unknown(result)
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
