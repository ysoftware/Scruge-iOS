//
//  MilestoneCell.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class MilestoneCell: UICollectionViewCell {

	@IBOutlet weak var dateLabel:UILabel!
	@IBOutlet weak var descriptionLabel:UILabel!

	@discardableResult
	func setup(with vm:MilestoneVM) -> Self {
		localize()
		
		descriptionLabel.text = vm.description
		dateLabel.text = "\(vm.date)\n\(vm.fundsRelease)"
		return self
	}
}
