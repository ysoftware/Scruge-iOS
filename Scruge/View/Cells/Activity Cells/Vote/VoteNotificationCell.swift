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
		localize()

		selectionStyle = .none
		#warning("refactor to view model")

		let voteKindText = vote.voting.kind == .extend
			? R.string.localizable.label_voting_to_extend()
			: R.string.localizable.label_voting_to_release_funds()

		titleLabel.text = R.string.localizable.label_voting_to_for(voteKindText, vote.campaign.title)
		dateLabel.text = Date.presentRelative(vote.voting.endTimestamp,
											  future: R.string.localizable.label_campaign_ends(),
											  past: R.string.localizable.label_campaign_ended())
		return self
	}
}
