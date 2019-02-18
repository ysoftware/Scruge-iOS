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

	private var timestamp:Int64 = 0

	#warning("refactor to view model")

	@discardableResult
	func setup(title:String, timestamp:Int64) -> Self {
		localize()
		
		selectionStyle = .none
		titleLabel.text = title
		self.timestamp = timestamp
		refresh()
		return self
	}

	private func refresh() {
		let diff = max(0, timestamp - Date().milliseconds)

		let days = diff /  Time.day
		let hours = (diff - days *  Time.day) / Time.hour
		let minutes = (diff - days *  Time.day - hours * Time.hour) / Time.minute

		daysLabel.text = "\(days)"
		hoursLabel.text = "\(hours)"
		minutesLabel.text = "\(minutes)"
	}

	func beginRefreshing() {
		#warning("timer")
	}

	func endRefreshing() {
		#warning("timer")
	}
}
