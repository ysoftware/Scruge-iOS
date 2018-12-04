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

		#warning("refactor to view model")

		let voteKindText = vote.voting.kind == .extend ? "extend deadline" : "continue campaign"
		titleLabel.text = "Voting to \(voteKindText) for \(vote.campaign.title)"
		let date = Date(milliseconds: vote.voting.endTimestamp)
		dateLabel.text = date.toRelative(locale: Locales.english)

		return self
	}
}