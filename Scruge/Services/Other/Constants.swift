//
//  Constants.swift
//  Scruge
//
//  Created by ysoftware on 03/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

struct Time {

	static let minute:Int64 = 1000 * 60

	static let hour = 60 * minute

	static let day = 24 * hour
}

struct Constants {

	let color = Color()

	struct Color {

		let purpleLight = #colorLiteral(red: 0.6901960784, green: 0.4745098039, blue: 0.9568627451, alpha: 1)

		let purple = #colorLiteral(red: 0.4745098039, green: 0.2470588235, blue: 0.7568627451, alpha: 1)

		let gray = #colorLiteral(red: 0.8549019608, green: 0.8509803922, blue: 0.8862745098, alpha: 1)

		let grayLight = #colorLiteral(red: 0.9450980392, green: 0.9529411765, blue: 0.9607843137, alpha: 1)

		let grayTitle = #colorLiteral(red: 0.2705882353, green: 0.3176470588, blue: 0.3294117647, alpha: 1)

		let grayText = #colorLiteral(red: 0.4483847022, green: 0.4429452121, blue: 0.5144024491, alpha: 1)

		let greenLight = #colorLiteral(red: 0.7098039216, green: 0.8901960784, blue: 0.3215686275, alpha: 1)

		let green = #colorLiteral(red: 0.5843137255, green: 0.7882352941, blue: 0.1294117647, alpha: 1)

		// resources

		let cpu = #colorLiteral(red: 0.9882352941, green: 0.8156862745, blue: 0.3294117647, alpha: 1)

		let net = #colorLiteral(red: 0.2235294118, green: 0.5843137255, blue: 0.8431372549, alpha: 1)

		let ram = #colorLiteral(red: 0.5058823529, green: 0.7882352941, blue: 0.1921568627, alpha: 1)

		let cpuBackground = #colorLiteral(red: 0.79, green: 0.6495555556, blue: 0.2633333333, alpha: 1)

		let netBackground = #colorLiteral(red: 0.1696744186, green: 0.4435348837, blue: 0.64, alpha: 1)

		let ramBackground = #colorLiteral(red: 0.3786567164, green: 0.59, blue: 0.1438308457, alpha: 1)
	}
}
