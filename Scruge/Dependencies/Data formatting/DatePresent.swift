//
//  DatePresent.swift
//  Scruge
//
//  Created by ysoftware on 18/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import SwiftDate

extension Date {

	static func present(_ milliseconds:Int, as format:String) -> String {
		return Date(milliseconds: milliseconds)
			.convertTo(region: .current)
			.toFormat(format)
	}
}
