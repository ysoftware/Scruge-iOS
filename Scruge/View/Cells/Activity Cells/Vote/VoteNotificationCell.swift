//
//  VoteNotificationCell.swift
//  Scruge
//
//  Created by ysoftware on 04/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import SwiftDate

final class VoteNotificationCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!

	@discardableResult
	func setup(with vote:Voting) -> Self {

		selectionStyle = .none
		#warning("refactor to view model")

		let voteKindText = vote.voting.kind == .extend ? "extend deadline" : "continue campaign"
		titleLabel.text = "Voting to \(voteKindText) for \(vote.campaign.title)"
		dateLabel.text = Date.presentRelative(vote.voting.endTimestamp,
											  future: "ends",
											  past: "ended")
		return self
	}
}
