//
//  UpdateResp.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct UpdateListResponse: Codable {

	let result:Int

	let data:[Update]
}
