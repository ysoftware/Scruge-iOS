//
//  CampaignCell.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import Kingfisher

final class CampaignCell: UITableViewCell {

	@IBOutlet weak var topImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var raisedLabel: UILabel!
	@IBOutlet weak var leftLabel: UILabel!
	@IBOutlet weak var rightLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var progressConstraint: NSLayoutConstraint!

	func setup(_ vm:PartialCampaignVM) -> CampaignCell {

		if let url = URL(string: vm.imageUrl) {
			topImage.kf.setImage(with: url)
		}

		titleLabel.text = vm.title
		descriptionLabel.text = vm.description
		leftLabel.text = vm.raisedText
		rightLabel.text = vm.daysLeft
		progressConstraint = changeMultiplier(to: CGFloat(vm.progress), for: progressConstraint)
		return self
	}
}
