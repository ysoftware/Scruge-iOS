//
//  Networking.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import SwiftHTTP
import Result

struct Network:Networking {

	private let activity = ActivityIndicatorController()
	private let baseUrl:String
	var isLoggingEnabled = true

	init(baseUrl:String = "http://35.242.235.123/") {
		self.baseUrl = baseUrl
	}

	func upload(_ request:String,
				_ params:[String:Any]?,
				data:Data,
				fileName:String,
				mimeType:String,
				_ completion: @escaping (Result<ResultResponse, AnyError>)->Void) {

		var parameters = params ?? [:]
		parameters["image"] = Upload(data: data, fileName: fileName, mimeType: mimeType)
		log("POST", request, parameters)
		activity.beginAnimating()

		HTTP.POST(baseUrl + request,
				  parameters: parameters) { response in
					self.handleResponse(response, completion)
		}
	}

	func get<T:Codable>(_ request:String,
						_ params:HTTPParameterProtocol?,
						_ completion: @escaping (Result<T, AnyError>)->Void) {

		log("GET", request, params)
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

		log("POST", request, params)
		activity.beginAnimating()

		HTTP.POST(baseUrl + request,
				  parameters: params,
				  requestSerializer: JSONParameterSerializer()) { response in
					self.handleResponse(response, completion)
		}
	}

	func put<T:Codable>(_ request:String,
						_ params:HTTPParameterProtocol?,
						_ completion: @escaping (Result<T, AnyError>)->Void) {

		log("PUT", request, params)
		activity.beginAnimating()

		HTTP.PUT(baseUrl + request,
				 parameters: params,
				 requestSerializer: JSONParameterSerializer()) { response in
					self.handleResponse(response, completion)
		}
	}

	private func handleResponse<T:Codable>(_ response: (Response?),
										   _ completion: @escaping (Result<T, AnyError>)->Void) {
		DispatchQueue.main.async {
			self.activity.endAnimating()
			
			guard let response = response else {
				self.log(nil, "No response.")
				return completion(.failure(AnyError(NetworkingError.connectionProblem)))
			}

			if let error = response.error {
				self.log(response, "Error: \(response.statusCode ?? -1)")
				return completion(.failure(AnyError(error)))
			}

			guard let object = T.init(response.data) else {
				let string = String(data: response.data, encoding: .utf8) ?? ""
				self.log(response, "Could not parse object.\n\(string)")
				return completion(.failure(AnyError(BackendError.parsingError)))
			}

			self.log(response, "\(object.toDictionary())")
			completion(.success(object))
		}
	}

	// MARK: - Logging

	private func log(_ response:Response?, _ string:String) {
		if isLoggingEnabled {
			print("RESPONSE: \(response?.URL?.path ?? "")\n\(string)\n")
		}
	}

	private func log(_ request:String, _ method:String, _ params:HTTPParameterProtocol?) {
		if isLoggingEnabled {
			print("\(request): /\(method)\n\(params ?? [:])\n")
		}
	}
}
