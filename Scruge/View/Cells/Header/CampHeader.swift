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
		localize()

		titleLabel.text = "Last update"
		rightLabel.text = vm.date
		return self
	}

	@discardableResult
	func setup(with vm:MilestoneVM) -> Self {
		localize()

		titleLabel.text = "Current milestone"
		rightLabel.text = ""
		return self
	}

	@discardableResult
	func setup(with vm:CommentAVM, for campaignVM:CampaignVM) -> Self {
		localize()

		titleLabel.text = "Comments"
		rightLabel.text = "\(campaignVM.commentsCount)"
		return self
	}

	@discardableResult
	func setup(with vm:RewardAVM) -> Self {
		localize()

		titleLabel.text = "Rewards"
		rightLabel.text = ""
		return self
	}

	@discardableResult
	func setup(with vm:DocumentAVM) -> Self {
		localize()

		titleLabel.text = "Documents"
		rightLabel.text = "\(vm.numberOfItems)"
		return self
	}

	@discardableResult
	func setup(with vm:FaqAVM) -> Self {
		localize()

		titleLabel.text = "Frequently asked questions"
		rightLabel.text = "\(vm.numberOfItems)"
		return self
	}

	@discardableResult
	func setup(as title:String, _ description:String? = nil) -> Self {
		localize()
		
		titleLabel.text = title
		rightLabel.text = description
		return self
	}
}
