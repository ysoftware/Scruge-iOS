//
//  DatePresent.swift
//  Scruge
//
//  Created by ysoftware on 18/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import SwiftDate

extension Date {

	static func present(_ milliseconds:Int64, as format:String) -> String {
		return Date(seconds: TimeInterval(milliseconds / 1000))
			.convertTo(region: .current)
			.toFormat(format)
	}

	static func presentRelative(_ milliseconds:Int64, future:String = "", past:String = "") -> String {
		let string = Date().milliseconds > milliseconds ? past : future
		let date = Date(seconds: TimeInterval(milliseconds / 1000)).toRelative(locale: Locale.current)
		return "\(string) \(date)".trimmingCharacters(in: .whitespaces)
	}
}
