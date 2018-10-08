//
//  Networking.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import SwiftHTTP
import Result

protocol Networking {

	func get<T:Codable>(_ request:String,
			 _ params:HTTPParameterProtocol?,
			 _ completion: @escaping (Result<T, AnyError>)->Void)

	func post<T:Codable>(_ request:String,
			  _ params:HTTPParameterProtocol?,
			  _ completion: @escaping (Result<T, AnyError>)->Void)

	func upload<T:Codable>(_ request:String,
						   data:Data,
						   fileName:String,
						   mimeType:String,
						   _ completion: @escaping (Result<T, AnyError>)->Void)
}

struct Network:Networking {

	private let activity = ActivityIndicatorController()
	private let baseUrl:String

	init(baseUrl:String = "http://35.234.70.252/") {
		self.baseUrl = baseUrl
	}

	func upload<T:Codable>(_ request:String,
						   data:Data,
						   fileName:String,
						   mimeType:String,
						   _ completion: @escaping (Result<T, AnyError>)->Void) {
		activity.beginAnimating()

		HTTP.POST(baseUrl + request,
				  parameters: Upload(data: data, fileName: fileName, mimeType: mimeType)) { response in
					self.handleResponse(response, completion)
		}
	}

	func get<T:Codable>(_ request:String,
			 _ params:HTTPParameterProtocol?,
			 _ completion: @escaping (Result<T, AnyError>)->Void) {

		activity.beginAnimating()
		HTTP.GET(baseUrl + request,
				 parameters: params,
				 requestSerializer: JSONParameterSerializer()) { response in
					self.handleResponse(response, completion)
		}
	}

	func post<T:Codable>(_ request:String,
			  _ params:HTTPParameterProtocol?,
			  _ completion: @escaping (Result<T, AnyError>)->Void) {

		activity.beginAnimating()
		HTTP.POST(baseUrl + request,
				 parameters: params,
				 requestSerializer: JSONParameterSerializer()) { response in
					self.handleResponse(response, completion)
		}
	}

	func handleResponse<T:Codable>(_ response: (Response?),
								   _ completion: @escaping (Result<T, AnyError>)->Void) {
		DispatchQueue.main.async {
			self.activity.endAnimating()
			
			guard let response = response else {
				return completion(.failure(AnyError(NetworkingError.connectionProblem)))
			}

			if let error = response.error {
				return completion(.failure(AnyError(error)))
			}

			guard let object = T.init(response.data) else {
				return completion(.failure(AnyError(NetworkingError.parsingError)))
			}

			completion(.success(object))
		}
	}
}
