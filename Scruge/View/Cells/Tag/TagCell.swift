//
//  TagCell.swift
//  Scruge
//
//  Created by ysoftware on 09/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class TagCell: UICollectionViewCell {

	@IBOutlet weak var backView: RoundedView!
	@IBOutlet weak var tagLabel:UILabel!

	@discardableResult
	func setup(with tag:String) -> Self {
		localize()
		
		tagLabel.text = "#\(tag)"
		return self
	}

	@discardableResult
	func setSelected(_ value:Bool) -> Self {
		backView.backgroundColor = value ? .black : .gray
		return self
	}
}
