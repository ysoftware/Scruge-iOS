//
//  DocumentCell.swift
//  Scruge
//
//  Created by ysoftware on 12/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class DocumentCell: UITableViewCell {

	@IBOutlet weak var nameLabel:UILabel!

	@discardableResult
	func setup(with vm:DocumentVM) -> Self {
		localize()
		
		nameLabel.text = vm.name
		selectionStyle = .none
		return self
	}
}
