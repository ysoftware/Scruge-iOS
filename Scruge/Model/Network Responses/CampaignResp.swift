//
//  CampaignResp.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct CampaignResponse: Codable {

	let campaign:Campaign
}

struct CampaignListResponse: Codable {

	let campaigns:[PartialCampaign]
}
