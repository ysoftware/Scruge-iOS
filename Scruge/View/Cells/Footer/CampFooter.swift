//
//  CampaignBottom.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class CampaignFooter: UITableViewHeaderFooterView {

	@IBOutlet weak var label: UILabel!

	@discardableResult
	func setup(with string:String) -> Self {
		localize()
		
		label.text = string
		return self
	}
}
