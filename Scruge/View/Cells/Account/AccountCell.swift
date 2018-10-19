//
//  AccountCell.swift
//  Scruge
//
//  Created by ysoftware on 19/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class AccountCell: UITableViewCell {

	@IBOutlet weak var nameLabel:UILabel!
	@IBOutlet weak var balanceLabel:UILabel!

	@discardableResult
	func setup(with vm:AccountVM) -> Self {
		nameLabel.text = vm.name
		balanceLabel.text = vm.balanceString
		return self
	}
}
