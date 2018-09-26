//
//  Networking.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import SwiftHTTP
import Result

enum NetworkingError:Error {

	case connectionError

	case incorrectRequest

	case serverError

	case unknown(Int)
}

protocol Networking {

	func get<T:Codable>(_ request:String,
			 _ params:HTTPParameterProtocol?,
			 _ completion: @escaping (Result<T, NetworkingError>)->Void)

	func post<T:Codable>(_ request:String,
			  _ params:HTTPParameterProtocol?,
			  _ completion: @escaping (Result<T, NetworkingError>)->Void)
}

struct Network:Networking {

	var baseUrl:String

	init(baseUrl:String) {
		self.baseUrl = baseUrl
	}

	func get<T:Codable>(_ request:String,
			 _ params:HTTPParameterProtocol?,
			 _ completion: @escaping (Result<T, NetworkingError>)->Void) {

		HTTP.GET(baseUrl + request,
				 parameters: params,
				 requestSerializer: JSONParameterSerializer()) { response in
					self.handleResponse(response, completion)
		}
	}

	func post<T:Codable>(_ request:String,
			  _ params:HTTPParameterProtocol?,
			  _ completion: @escaping (Result<T, NetworkingError>)->Void) {

		HTTP.POST(baseUrl + request,
				 parameters: params,
				 requestSerializer: JSONParameterSerializer()) { response in
					self.handleResponse(response, completion)
		}
	}

	func handleResponse<T:Codable>(_ response: (Response?),
								   _ completion: (Result<T, NetworkingError>)->Void) {
		guard let response = response,
			let result = T.init(response.data)
			else {
				return completion(Result<T, NetworkingError>.failure(.connectionError))
		}
		completion(.success(result))
	}
}
