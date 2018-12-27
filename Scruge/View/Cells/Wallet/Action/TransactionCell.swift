//
//  ActionCell.swift
//  Scruge
//
//  Created by ysoftware on 27/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class TransactionCell: UITableViewCell {

	@IBOutlet weak var actionNameLabel: UILabel!
	@IBOutlet weak var actionDetailsLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!

	@discardableResult
	func setup(_ vm:ActionVM) -> Self {
		actionNameLabel.attributedText = vm.actionName
		actionDetailsLabel?.attributedText = vm.actionDetails
		dateLabel.text = vm.time
		return self
	}
}
