//
//  DateMilliseconds.swift
//  Scruge
//
//  Created by ysoftware on 03/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

extension Date {

	var milliseconds:Int {
		return Int(timeIntervalSince1970 * 1000)
	}
}
