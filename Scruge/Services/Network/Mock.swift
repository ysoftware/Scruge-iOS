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
		case "campaigns": data = campaignsList()
		case "auth/login", "auth/register": data = auth()
		default: return completion(.failure(AnyError(NetworkingError.connectionProblem)))
		}

		guard let object = T.init(data) else {
			return completion(.failure(AnyError(NetworkingError.parsingError)))
		}
		completion(.success(object))
	}

	func auth() -> Data {
		return """
			{
				"data": [
					"success":true,
					"token":"\(UUID().uuidString)"
				]
			}
		""".data(using: .utf8)!
	}

	func campaignsList() -> Data {
		return """
			{
				"data": [
					{
						"id":"\(UUID().uuidString)",
						"title":"The Matrix",
						"image":"https://ksassets.timeincuk.net/wp/uploads/sites/55/2017/03/matrix_reboot_1000-630x400-1.jpg",
						"description":"A programmer is brought back to reason and reality when learning he was living in a program created by gigantic machines which make human birth artificial. In order to set humanity free, Neo will have to face many enemies by using technologies and self-trust.",
						"endTimestamp":0,
						"raisedAmount":12345,
						"fundAmount":123456
					},
					{
						"id":"\(UUID().uuidString)",
						"title":"The Matrix: Reloaded",
						"image":"https://i.ytimg.com/vi/GOVS6iCJ52s/maxresdefault.jpg",
						"description":"Neo and the rebel leaders estimate that they have 72 hours until 250,000 probes discover Zion and destroy it and its inhabitants. During this, Neo must decide how he can save Trinity from a dark fate in his dreams.",
						"endTimestamp":0,
						"raisedAmount":12345,
						"fundAmount":54321
					},
					{
						"id":"\(UUID().uuidString)",
						"title":"The Matrix Revolutions",
						"image":"http://www.postapoc-media.com/wp-content/uploads/2013/02/matrix-revolutions-31.jpg",
						"description":"The human city of Zion defends itself against the massive invasion of the machines as Neo fights to end the war at another front while also opposing the rogue Agent Smith.",
						"endTimestamp":0,
						"raisedAmount":12345,
						"fundAmount":54321
					}
				]
			}
			""".data(using: .utf8)!
	}
}
