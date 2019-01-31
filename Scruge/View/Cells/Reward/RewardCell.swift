//
//  RewardCell.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class RewardCell: UITableViewCell {

	@IBOutlet weak var fundingLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var availableLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	@discardableResult
	func setup(with vm: RewardVM) -> Self {
		localize()
		
		fundingLabel.text = vm.amount
		titleLabel.text = vm.title
		descriptionLabel.text = vm.description

		if let availableString = vm.availableString {
			availableLabel.isHidden = false
			availableLabel.text = availableString
		}
		else {
			availableLabel.isHidden = true
		}
		return self
	}
}
