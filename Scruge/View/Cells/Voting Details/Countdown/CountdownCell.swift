//
//  CountdownCell.swift
//  Scruge
//
//  Created by ysoftware on 03/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class CountdownCell: UITableViewCell {

	@IBOutlet var titleLabel:UILabel!
	@IBOutlet var hoursLabel:UILabel!
	@IBOutlet var minutesLabel:UILabel!
	@IBOutlet var daysLabel:UILabel!

	private var timestamp:Int = 0

	@discardableResult
	func setup(title:String, timestamp:Int) -> Self {
		selectionStyle = .none
		titleLabel.text = title
		self.timestamp = 1544014745000 // timestamp
		refresh()
		return self
	}

	private func refresh() {
		let MINUTE = 1000 * 60
		let HOUR = 60 * MINUTE
		let DAY = 24 * HOUR

		let diff = max(0, timestamp - Date().milliseconds)

		let days = diff / DAY
		let hours = (diff - days * DAY) / HOUR
		let minutes = (diff - days * DAY - hours * HOUR) / MINUTE

		daysLabel.text = "\(days)"
		hoursLabel.text = "\(hours)"
		minutesLabel.text = "\(minutes)"
	}

	func beginRefreshing() {
		// TO-DO: timer
	}

	func endRefreshing() {
		// TO-DO: timer
	}
}
