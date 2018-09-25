//
//  Campaign.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

// These types should reflect json tree of backend response.

struct CampaignResponse: Codable {

	var campaign:Campaign
}

struct CampaignListResponse: Codable {

	var campaigns:[Campaign]
}
