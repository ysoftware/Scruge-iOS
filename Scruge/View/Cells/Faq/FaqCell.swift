//
//  FaqCell.swift
//  Scruge
//
//  Created by ysoftware on 12/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.

import UIKit

final class FaqCell: UITableViewCell {

	@IBOutlet weak var questionLabel:UILabel!
	@IBOutlet weak var answerLabel:UILabel!

	@discardableResult
	func setup(with vm:FaqVM) -> Self {
		questionLabel.text = vm.question
		answerLabel.text = vm.answer
		return self
	}


	#warning("temporary fix")
	@discardableResult
	func setup(with vm:TechnicalVM) -> Self {
		questionLabel.text = vm.name
		answerLabel.text = vm.value
		return self
	}

}
