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

// extract Error from Result's AnyError
private func extractError(_ error:Error) -> Error {
	if let any = error as? AnyError {
		return any.error
	}
	return error
}

func makeError(_ error:Error) -> String {
	let error = extractError(error)
	if let authError = error as? AuthError {
		switch authError {
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
