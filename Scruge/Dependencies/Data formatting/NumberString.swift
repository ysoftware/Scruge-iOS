//
//  NumberString.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

extension Double {

	func formatRounding(to decimalPlaces:Int = 1,
						min:Int = 0,
						separateWith separator:String? = "") -> String {
		let formatter = NumberFormatter()
		formatter.minimumFractionDigits = min
		formatter.maximumFractionDigits = decimalPlaces
		formatter.groupingSeparator = separator
		formatter.minimumIntegerDigits = 1
		return formatter.string(for: self)!
	}

	func formatDecimal(separateWith separator:String? = "") -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.groupingSeparator = separator
		formatter.maximumFractionDigits = 4
		formatter.minimumFractionDigits = 0
		return formatter.string(for: self)!
	}
}

extension Int {

	func formatDecimal(separateWith separator:String? = "") -> String {
		return Double(self).formatDecimal(separateWith: separator)
	}
}
