//
//  VoteResultCell.swift
//  Scruge
//
//  Created by ysoftware on 04/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class VoteResultCell: UITableViewCell {

	@IBOutlet weak var progressFullView: RoundedView!
	@IBOutlet weak var positiveViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var noPercentLabel: UILabel!
	@IBOutlet weak var yesPercentLabel: UILabel!

	@discardableResult
	func setup(with result:VoteResult?) -> Self {
		let width = progressFullView.bounds.width
		
		guard let result = result else {
			positiveViewLeadingConstraint.constant = width
			noPercentLabel.text = "..."
			yesPercentLabel.text = "..."
			return self
		}

		let onePercent = result.voters / 100
		let positivePercent = result.positiveVotes / onePercent
		let negativePercent = (result.voters - result.positiveVotes) / onePercent

		positiveViewLeadingConstraint.constant = width * CGFloat(positivePercent) / 100
		noPercentLabel.text = "\(negativePercent)%"
		yesPercentLabel.text = "\(positivePercent)%"
		return self
	}
}
