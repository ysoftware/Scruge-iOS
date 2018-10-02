//
//  CategoryCell.swift
//  Scruge
//
//  Created by ysoftware on 29/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class CategoryCell: UITableViewCell {

	@IBOutlet weak var titleLabel:UILabel!

	@discardableResult
	func setup(with vm:CategoryVM) -> CategoryCell {

		titleLabel.text = vm.name
		return self
	}
}
