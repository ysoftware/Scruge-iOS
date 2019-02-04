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

	static func presentRelative(_ millsedonds:Int, future:String = "", past:String = "") -> String {
		let string = Date().milliseconds > millsedonds ? past : future
		let date = Date(milliseconds: millsedonds).toRelative(locale: Locale.current)
		return "\(string) \(date)".trimmingCharacters(in: .whitespaces)
	}
}
