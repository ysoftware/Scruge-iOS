//
//  CampaignHeader.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class CampaignHeader: UITableViewHeaderFooterView {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var rightLabel: UILabel!

	@discardableResult
	func setup(with vm:UpdateVM) -> Self {
		titleLabel.text = "Last update"
		rightLabel.text = vm.date
		return self
	}

	@discardableResult
	func setup(with vm:MilestoneVM) -> Self {
		titleLabel.text = "Current milestone"
		rightLabel.text = ""
		return self
	}

	@discardableResult
	func setup(with vm:CommentAVM, for campaignVM:CampaignVM) -> Self {
		titleLabel.text = "Comments"
		rightLabel.text = campaignVM.totalCommentsCount
		return self
	}

	@discardableResult
	func setup(with vm:RewardAVM) -> Self {
		titleLabel.text = "Rewards"
		rightLabel.text = ""
		return self
	}
}
