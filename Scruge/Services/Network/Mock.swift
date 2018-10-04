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
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		handle(request: request, completion)
	}

	func post<T:Codable>(_ request: String,
						 _ params: HTTPParameterProtocol?,
						 _ completion: @escaping (Result<T, AnyError>) -> Void) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		handle(request: request, completion)
	}

	func handle<T:Codable>(request:String,
						   _ completion:  @escaping (Result<T, AnyError>) -> Void) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
			UIApplication.shared.isNetworkActivityIndicatorVisible = false

			let json:String
			switch request {
			case "campaigns": json = self.campaignsList()
			case "campaign/1": json = self.campaign()
			case "auth/login": json = self.login()
			case "auth/register": json = self.register()
			case "categories": json = self.categories()
			case "campaign/1/updates": json = self.updates()
			case "campaign/1/comments": json = self.comments()
			case "campaign/1/milestones": json = self.milestones()
			case "profile": json = self.profile()
			default: return completion(.failure(AnyError(NetworkingError.unknown)))
			}

			guard let object = T.init(json.data(using: .utf8)!) else {
				return completion(.failure(AnyError(NetworkingError.parsingError)))
			}
			completion(.success(object))
		}
	}

	private func profile() -> String {
		return """
		{
			"data": {
				"email": "ysoftware@yandex.ru",
				"description": "I'm in your area!"
			}
		}
		"""
	}

	private func milestones() -> String {
		return """
		{
			"data": [
				{
					"id": "0",
					"title":"Post-Production",
					"endTimestamp":1554199676000,
					"campaignId":"1",
					"description": "We edit it and put some effects on."
				},
				{
					"id": "1",
					"title":"Filming",
					"endTimestamp":1567345924000,
					"campaignId":"1",
					"description": "We film everything."
				},
				{
					"id": "2",
					"title":"Casting",
					"endTimestamp":1551426824000,
					"campaignId":"1",
					"description": "We're supposed to finish casting and compose the whole crew by this time."
				}
			]
		}
		"""
	}

	private func comments() -> String {
		return """
		{
			"data": [
				{
					"id":"1",
					"authorName": "Darius X",
					"text":"Can not wait for this movie! The idea looks so interesting.",
					"timestamp":1538380424000
				},
				{
					"id":"2",
					"text":"They better cast Keanu Reeves or I'm taking my money back!",
					"timestamp":1538179044000
				},
				{
					"id":"3",
					"text":"The story and the philosophy is mind-blowing! This is going to be a great movie!",
					"timestamp":1537975044000
				},
				{
					"id":"4",
					"authorName": "Michael Stevens",
					"text":"Who needs so much philosophy in a movie? Please just add more action.",
					"timestamp":1537771044000
				},
				{
					"id":"5",
					"text":"I will support all of your projects guys. Love you!",
					"timestamp":1537468044000
				},
				{
					"id":"6",
					"text":"Looks nice.",
					"timestamp":1537468044000
				},
				{
					"id":"7",
					"text":"I love complicated movies",
					"timestamp":1537468044000
				},
				{
					"id":"8",
					"text":"Great project.",
					"timestamp":1537468044000
				}
			]
		}
		"""
	}

	private func updates() -> String {
		return """
		{
			"data": [
				{
					"id":"2",
					"campaignId":"1",
					"title":"Writer's blog: Day 12",
					"imageUrl":"https://assets.rebelcircus.com/blog/wp-content/uploads/2016/03/article-2222541-15A98BAC000005DC-820_634x429-e1457975643432.jpg",
					"timestamp":1538380424000,
					"description":"I'm going to tell you about some philosophy of choice and free will in the Matrix."
				},
				{
					"id":"1",
					"campaignId":"1",
					"title":"Filming Locations: Syndney",
					"imageUrl":"https://files.sharenator.com/The-Matrix1-Famous-Movie-Locations-s1279x729-416679.png",
					"timestamp":1537344468000,
					"description":"We've found the right kind of look we wanted to make our movie to fit in. Look at some beautiful locations in Sydney we're going to try to use in filming."
				},
				{
					"id":"0",
					"campaignId":"1",
					"title":"Technical Specifications: Panavision Panaflex Platinum",
					"imageUrl":"https://www.panavision.com/sites/default/files/pictures/products/1_PFXP_Studio_0_RGB_flat012011.jpg",
					"timestamp":1536395416000,
					"description":"We're going to rent Panavision Panaflex Platinum camera for the shooting. 35mm and aspect ratio of 2.39:1 will give the movie just the right look and feel to reflect the story of the world of Matrix."
				}
			]
		}
		"""
	}

	private func campaign() -> String {
		return """
		{
			"data": {
				"id":"1",
				"type":"1",
				"title":"The Matrix",
				"imageUrl":"https://ksassets.timeincuk.net/wp/uploads/sites/55/2017/03/matrix_reboot_1000-630x400-1.jpg",
				"description":"A programmer is brought back to reason and reality when learning he was living in a program created by gigantic machines which make human birth artificial. In order to set humanity free, Neo will have to face many enemies by using technologies and self-trust.",
				"endTimestamp":1546329224000,
				"raisedAmount":12000000,
				"fundAmount":63000000,

				"mediaUrl":"https://www.youtube-nocookie.com/embed/m8e-FF8MsqU?playsinline=1&rel=0&controls=0&showinfo=0",
				"totalCommentsCount": 8,
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
					"id": "2",
					"title":"Casting",
					"endTimestamp":1551426824000,
					"campaignId":"1",
					"description": "We're supposed to finish casting and compose the whole crew by this time."
				},

				"lastUpdate": {
					"id":"3",
					"campaignId":"1",
					"title":"Writer's blog: Day 12",
					"imageUrl":"https://assets.rebelcircus.com/blog/wp-content/uploads/2016/03/article-2222541-15A98BAC000005DC-820_634x429-e1457975643432.jpg",
					"timestamp":1538380424000,
					"description":"I'm going to tell you about some philosophy of choice and free will in the Matrix."
				},

				"topComments": [
					{
						"id":"1",
						"authorName": "Darius X",
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

	private func login() -> String {
		return """
		{
			"result":0,
			"token":"some-auth-token-value"
		}
		"""
	}

	private func register() -> String {
		return """
		{
			"result":0
		}
		"""
	}

	private func campaignsList() -> String {
		return """
		{
			"data": [
				{
					"id":"1",
					"type":"1",
					"title":"The Matrix",
					"imageUrl":"https://ksassets.timeincuk.net/wp/uploads/sites/55/2017/03/matrix_reboot_1000-630x400-1.jpg",
					"description":"A programmer is brought back to reason and reality when learning he was living in a program created by gigantic machines which make human birth artificial. In order to set humanity free, Neo will have to face many enemies by using technologies and self-trust.",
					"endTimestamp":1546329224000,
					"raisedAmount":12000000,
					"fundAmount":63000000
				},
				{
					"id":"2",
					"type":"1",
					"title":"The Matrix: Reloaded",
					"imageUrl":"https://i.ytimg.com/vi/GOVS6iCJ52s/maxresdefault.jpg",
					"description":"Neo and the rebel leaders estimate that they have 72 hours until 250,000 probes discover Zion and destroy it and its inhabitants. During this, Neo must decide how he can save Trinity from a dark fate in his dreams.",
					"endTimestamp":1601646231000,
					"raisedAmount":7000000,
					"fundAmount":150000000
				},
				{
					"id":"3",
					"type":"1",
					"title":"The Matrix Revolutions",
					"imageUrl":"http://www.postapoc-media.com/wp-content/uploads/2013/02/matrix-revolutions-31.jpg",
					"description":"The human city of Zion defends itself against the massive invasion of the machines as Neo fights to end the war at another front while also opposing the rogue Agent Smith.",
					"endTimestamp":1664718231000,
					"raisedAmount":0.00005,
					"fundAmount":22896
				}
			]
		}
		"""
	}

	func categories() -> String {
		return """
		{
			"data": [
				{ "name":"Art", "id":"1" },
				{ "name":"Comics", "id":"2" },
				{ "name":"Crafts", "id":"3" },
				{ "name":"Design", "id":"4" },
				{ "name":"Fashion", "id":"5" },
				{ "name":"Film&Video", "id":"6" },
				{ "name":"Games", "id":"7" },
				{ "name":"Music", "id":"8" },
				{ "name":"Publishing", "id":"9" },
				{ "name":"Technology", "id":"10" },
				{ "name":"Theater", "id":"11" }
			]
		}
		"""
	}
}
