//
//  VoteControlsCell.swift
//  Scruge
//
//  Created by ysoftware on 03/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class VoteControlsCell: UITableViewCell {

	@IBOutlet var yesButton:Button!
	@IBOutlet var noButton:Button!
	@IBOutlet var passcodeField:UITextField!

	private var block: ((String, Bool)->Void)?

	@discardableResult
	func vote(_ block: @escaping (String, Bool)->Void) -> Self {
		self.block = block
		yesButton.addClick(self, action: #selector(click))
		noButton.addClick(self, action: #selector(click))
		yesButton.color = Service.constants.color.green
		return self
	}

	@objc func click(_ sender:Button) {
		block?(passcodeField.text!, sender === yesButton.button)
	}
}
