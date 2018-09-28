//
//  CampaignResp.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// MARK: - Response

struct CampaignResponse: Codable {

	let data:Campaign?
}

struct CampaignListResponse: Codable {

	let data:[PartialCampaign]
}

// MARK: - Request

struct CampaignListRequest: Codable {

	let page:Int?

	let query:String?

	let categories:[String]?

	let tags:[String]?

	let token = TokenManager().getToken()
}
