//
//  ErrorTypes.swift
//  Scruge
//
//  Created by ysoftware on 01/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

enum GeneralError: Error, Equatable {

	case unknown
}

enum AuthError: Error, Equatable {

	case accountBlocked

	case accountExists

	case incorrectCredentials

	case invalidEmail

	case noToken // token not found but required

	case invalidToken // invalid user token passed

	case userNotFound // user not found for this token

	case incorrectEmailLength // 5 to 254 symbols

	case incorrectPasswordLength // 5 to 50 symbols
}

enum EOSError: Error, Equatable {

	case overdrawnBalance
	#warning("use this somehow?")

	case unknown

	case abiError
}

enum BackendError: Error, Equatable {

	case parsingError

	case resourceNotFound

	case invalidResourceId

	case notImplemented

	case unknown
}

enum NetworkingError: Error, Equatable {

	case connectionProblem

	case unknown
}

enum WalletError: Error, Equatable {

	case noAccounts

	case noKey

	case incorrectPasscode

	case noSelectedAccount

	case selectedAccountMissing

	case unknown
}
