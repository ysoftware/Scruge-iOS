//
//  EconomiesCell.swift
//  Scruge
//
//  Created by ysoftware on 23/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class EconomiesCell: UITableViewCell {

	@IBOutlet weak var tokenSupplyLabel: UILabel!
	@IBOutlet weak var publicPercentLabel: UILabel!
	@IBOutlet weak var initialReleaseLabel: UILabel!
	@IBOutlet weak var inflationLabel: UILabel!

	func setup(with vm:EconomiesVM) -> EconomiesCell {
		localize()
		
		tokenSupplyLabel.text = vm.tokenSupply
		publicPercentLabel.text = vm.publicPercent
		initialReleaseLabel.text = vm.initialRelease
		inflationLabel.text = vm.inflationRate
		return self
	}
}
