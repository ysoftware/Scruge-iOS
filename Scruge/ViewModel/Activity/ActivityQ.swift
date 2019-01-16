//
//  ActivityQ.swift
//  Scruge
//
//  Created by ysoftware on 16/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation
import MVVM

final class ActivityQ: Query {

	var page = 0

	func resetPosition() {
		page = 0
	}

	func advance() {
		page += 1
	}
}
