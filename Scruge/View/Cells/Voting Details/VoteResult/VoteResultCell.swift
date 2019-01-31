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
	@IBOutlet weak var positiveViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet weak var noPercentLabel: UILabel!
	@IBOutlet weak var yesPercentLabel: UILabel!

	private var result:VoteResult?

	@discardableResult
	func setup(with result:VoteResult?) -> Self {
		localize()
		
		self.result = result

		guard let result = self.result else {
			noPercentLabel.text = "…"
			yesPercentLabel.text = "…"
			return self
		}

		let onePercent = max(0.01, Double(result.voters) / 100)
		let positivePercent = Double(result.positiveVotes) / onePercent
		let negativePercent = Double(result.voters - result.positiveVotes) / onePercent

		noPercentLabel.text = negativePercent.formatRounding() + "%"
		yesPercentLabel.text = positivePercent.formatRounding() + "%"
		return self
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		guard let result = result else {
			return
		}

		let onePercent = max(0.01, Double(result.voters) / 100)
		let positivePercent = Double(result.positiveVotes) / onePercent
		positiveViewWidthConstraint = changeMultiplier(to: CGFloat(positivePercent / 100),
													   for: positiveViewWidthConstraint)
	}
}
