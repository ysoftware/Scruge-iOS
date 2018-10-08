//
//  TableHeaderTap.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

extension UITableViewHeaderFooterView {

	@discardableResult
	func addTap(target: Any, action: Selector, section:Int) -> Self {
		tag = section
		let tap = UITapGestureRecognizer(target: target, action: action)
		addGestureRecognizer(tap)
		return self
	}
}
