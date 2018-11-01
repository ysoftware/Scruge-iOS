//
//  ErrorTypes.swift
//  Scruge
//
//  Created by ysoftware on 01/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

enum AuthError: Error, Equatable {

	case accountBlocked

	case accountExists

	case incorrectCredentials

	case invalidEmail

	case authenticationFailed // passed empty token

	case incorrectEmailLength // 5 to 254 symbols

	case incorrectPasswordLength // 5 to 50 symbols
}

enum EOSError: Error, Equatable {

	case overdrawnBalance

	case unknown
}

enum BackendError: Error, Equatable {

	case parsingError

	case resourceNotFound

	case badRequest

	case notImplemented
}

enum NetworkingError: Error, Equatable {

	case connectionProblem

	case unknown
}

enum WalletError: Error, Equatable {

	case noAccounts

	case noKey

	case incorrectPasscode
}
