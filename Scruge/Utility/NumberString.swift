//
//  NumberString.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

extension Float {
	func format(roundingTo decimalPlaces:Int = 0) -> String {
		let formatter = NumberFormatter()
		formatter.minimumFractionDigits = 0
		formatter.maximumFractionDigits = decimalPlaces
		return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
	}
}

extension Double {
	func format(roundingTo decimalPlaces:Int = 1, min:Int = 0) -> String {
		let formatter = NumberFormatter()
		formatter.minimumFractionDigits = min
		formatter.maximumFractionDigits = decimalPlaces
		formatter.minimumIntegerDigits = 1
		return formatter.string(for: self)!
	}
}
