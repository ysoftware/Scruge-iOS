//
//  MockData.swift
//  Scruge
//
//  Created by ysoftware on 29/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import SwiftHTTP
import Result

struct Mock:Networking {

	func get<T:Codable>(_ request: String,
						_ params: HTTPParameterProtocol?,
						_ completion: @escaping (Result<T, AnyError>) -> Void) {
		handle(request: request, completion)
	}

	func post<T:Codable>(_ request: String,
						 _ params: HTTPParameterProtocol?,
						 _ completion: @escaping (Result<T, AnyError>) -> Void) {
		handle(request: request, completion)
	}

	func handle<T:Codable>(request:String,
						   _ completion:  @escaping (Result<T, AnyError>) -> Void) {
		let data:Data
		switch request {
		case "campaigns":
			data = campaignsList()
		default:
			return completion(.failure(AnyError(NetworkingError.connectionProblem)))
		}

		guard let object = T.init(data) else {
			return completion(.failure(AnyError(NetworkingError.parsingError)))
		}

		completion(.success(object))
	}

	func campaignsList() -> Data {
		return """
			{
				"data": [
					{
						"id":"\(UUID().uuidString)",
						"title":"Campaign 1",
						"image":"",
						"description":"Short description of campaign 1",
						"endTimestamp":0,
						"raisedAmount":12345,
						"fundAmount":123456
					},
					{
						"id":"\(UUID().uuidString)",
						"title":"Campaign 2: Resurrection",
						"image":"",
						"description":"Short description of campaign 2",
						"endTimestamp":0,
						"raisedAmount":12345,
						"fundAmount":123456
					}
				]
			}
			""".data(using: .utf8)!
	}
}
