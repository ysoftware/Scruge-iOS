//
//  MockData.swift
//  Scruge
//
//  Created by ysoftware on 29/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import SwiftHTTP
import Result

struct Mock {

	static func getProjects() -> ProjectsResponse {

		var projects:[Project] = []

		let economics = ProjectEconomics(tokenSupply: 250000000,
										 annualInflationPercent: Range(start: 0, end: 4),
										 listingTimestamp: nil,
										 exchange: Exchange(name: "Binance", url: ""))

		projects.append(Project(providerName: "provider",
								projectName: "Scruge",
								projectDescription: "Tokenized economy",
								videoUrl: "scruge.world",
								imageUrl: "http://api.scruge.world/resources/5c517cdfd93807029c58d895",
								social: [Social(url: "", name: "medium")],
								documents: [Document(name: "Whitepaper", url: "")],
								economics: economics))

		return ProjectsResponse(projects: projects)
	}
}
