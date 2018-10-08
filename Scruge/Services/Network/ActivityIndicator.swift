//
//  ActivityIndicator.swift
//  Scruge
//
//  Created by ysoftware on 08/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ActivityIndicatorController {

	private var count = 0

	func beginAnimating() {
		count += 1
		update()
	}

	func endAnimating() {
		count -= 1
		update()
	}

	func update() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = count > 0

		if count < 0 {
			count = 0
		}
	}
}
