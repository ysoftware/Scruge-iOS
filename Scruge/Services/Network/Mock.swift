//
//  MockData.swift
//  Scruge
//
//  Created by ysoftware on 29/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import SwiftHTTP
import Result

struct Mock: Networking {

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
		let json:String
		switch request {
		case "campaigns": json = campaignsList()
		case "campaign/1": json = campaign()
		case "auth/login", "auth/register": json = auth()
		default: return completion(.failure(AnyError(NetworkingError.connectionProblem)))
		}

		guard let object = T.init(json.data(using: .utf8)!) else {
			return completion(.failure(AnyError(NetworkingError.parsingError)))
		}
		completion(.success(object))
	}

	func campaign() -> String {
		return """
		{
			"data": {
				"id":"1",
				"title":"The Matrix",
				"mediaUrl":"https://www.youtube-nocookie.com/embed/m8e-FF8MsqU?playsinline=1&rel=0&controls=0&showinfo=0",
				"description":"A programmer is brought back to reason and reality when learning he was living in a program created by gigantic machines which make human birth artificial. In order to set humanity free, Neo will have to face many enemies by using technologies and self-trust.",
				"endTimestamp":1546329224000,
				"raisedAmount":12000000,
				"fundAmount":63000000,

				"totalCommentsCount": 5,
				"rewards": [
					{
						"id":"0",
						"amount":2,
						"title":"Thank you!",
						"description":"You get a pre recorded video of cast and crew saying thank you for all our funders."
					},
					{
						"id":"1",
						"amount":10,
						"title":"+ T shirt",
						"description":"You get a themed T-shirt",
						"additionalInfo": "Delivered by regular mailing service"
					},
					{
						"id":"2",
						"amount":50,
						"title":"+ DVD Box",
						"description":"You get a themed T-shirt and a DVD Box Set",
						"additionalInfo": "Delivered to you by quick mail"
					},
					{
						"id":"3",
						"amount":100,
						"title":"+ Signed Poster",
						"description":"You get a themed T-shirt, a DVD Box Set and a signed poster",
						"available": 80,
						"totalAvailable": 100,
						"additionalInfo": "Delivered to you by quick mail"
					}
				],

				"currentMilestone": {
					"id": "1",
					"title":"Casting",
					"endTimestamp":1551426824000,
					"campaignId":"1",
					"description": "We're supposed to finish casting and compose the whole crew by this time."
				},

				"lastUpdate": {
					"id":"1",
					"campaignId":"1",
					"title":"Writer's blog: Day 12",
					"timestamp":1538380424000,
					"description":"I'm going to tell you about some philosophy of choice and free will in the Matrix."
				},

				"lastComments": [
					{
						"id":"1",
						"text":"Can not wait for this movie! The idea looks so interesting.",
						"timestamp":1538380424000
					},
					{
						"id":"2",
						"text":"They better cast Keanu Reeves or I'm taking my money back!",
						"timestamp":1538379044000
					}
				]
			}
		}
		"""
	}

	func auth() -> String {
		return """
		{
			"data": [
				"success":true,
				"token":"some-auth-token-value"
			]
		}
		"""
	}

	func campaignsList() -> String {
		return """
		{
			"data": [
				{
					"id":"1",
					"title":"The Matrix",
					"imageUrl":"https://ksassets.timeincuk.net/wp/uploads/sites/55/2017/03/matrix_reboot_1000-630x400-1.jpg",
					"description":"A programmer is brought back to reason and reality when learning he was living in a program created by gigantic machines which make human birth artificial. In order to set humanity free, Neo will have to face many enemies by using technologies and self-trust.",
					"endTimestamp":1546329224000,
					"raisedAmount":12000000,
					"fundAmount":63000000
				},
				{
					"id":"2",
					"title":"The Matrix: Reloaded",
					"imageUrl":"https://i.ytimg.com/vi/GOVS6iCJ52s/maxresdefault.jpg",
					"description":"Neo and the rebel leaders estimate that they have 72 hours until 250,000 probes discover Zion and destroy it and its inhabitants. During this, Neo must decide how he can save Trinity from a dark fate in his dreams.",
					"endTimestamp":0,
					"raisedAmount":7000000,
					"fundAmount":150000000
				},
				{
					"id":"3",
					"title":"The Matrix Revolutions",
					"imageUrl":"http://www.postapoc-media.com/wp-content/uploads/2013/02/matrix-revolutions-31.jpg",
					"description":"The human city of Zion defends itself against the massive invasion of the machines as Neo fights to end the war at another front while also opposing the rogue Agent Smith.",
					"endTimestamp":0,
					"raisedAmount":12,
					"fundAmount":150000000
				}
			]
		}
		"""
	}
}
