//
//  FaqCell.swift
//  Scruge
//
//  Created by ysoftware on 12/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.

import UIKit

final class FaqCell: UICollectionViewCell {

	@IBOutlet weak var questionLabel:UILabel!
	@IBOutlet weak var answerLabel:UILabel!

	@discardableResult
	func setup(with vm:FaqVM) -> Self {
		localize()
		
		questionLabel.text = vm.question
		answerLabel.text = vm.answer
		return self
	}
}
