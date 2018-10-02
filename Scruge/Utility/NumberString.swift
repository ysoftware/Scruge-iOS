//
//  NumberString.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

extension Double {

	func formatRounding(to decimalPlaces:Int = 1, min:Int = 0) -> String {
		let formatter = NumberFormatter()
		formatter.minimumFractionDigits = min
		formatter.maximumFractionDigits = decimalPlaces
		formatter.minimumIntegerDigits = 1
		return formatter.string(for: self)!
	}

	func format(as style:NumberFormatter.Style) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = style
		formatter.maximumFractionDigits = 10
		return formatter.string(for: self)!
	}
}
