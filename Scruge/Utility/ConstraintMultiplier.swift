//
//  ConstraintMultiplier.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

extension UIView {

	func changeMultiplier(to multiplier:CGFloat,
						  for constraint: NSLayoutConstraint) -> NSLayoutConstraint {

		let newConstraint = NSLayoutConstraint(item: constraint.firstItem as Any,
											   attribute: constraint.firstAttribute,
											   relatedBy: constraint.relation,
											   toItem: constraint.secondItem,
											   attribute: constraint.secondAttribute,
											   multiplier: multiplier,
											   constant: constraint.constant)
		removeConstraint(constraint)
		addConstraint(newConstraint)
		newConstraint.isActive = true
		layoutIfNeeded()
		return newConstraint
	}
}
