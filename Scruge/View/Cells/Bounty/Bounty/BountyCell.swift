//
//  BountyCell.swift
//  Scruge
//
//  Created by ysoftware on 18/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class BountyCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!

	@discardableResult
	func setup(with vm:BountyVM) -> Self {
		selectionStyle = .none

		descriptionLabel.attributedText = vm.shortDescription
		dateLabel.text = vm.dates
		titleLabel.text = vm.name
		return self
	}
}
