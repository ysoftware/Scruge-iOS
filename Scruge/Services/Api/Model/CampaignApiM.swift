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

	let result:Int

	let campaign:Campaign?
}

struct CampaignListResponse: Codable {

	let result:Int

	let campaigns:[PartialCampaign]
}

// MARK: - Request

struct CampaignListRequest: Codable {

	init(from q: CampaignQuery?) {
		page = q?.page ?? 0
		query = q?.query
		category = q?.category?.model?.id
		tags = q?.tags
		type = q?.type
	}

	let page:Int

	let query:String?

	let category:String?

	let tags:[String]?

	let type:String?
}
