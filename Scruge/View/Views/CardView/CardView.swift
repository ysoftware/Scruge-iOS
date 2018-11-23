//
//  CardView.swift
//  Scruge
//
//  Created by ysoftware on 23/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class CardView: UIView {

	override func layoutSubviews() {
		let cornerRadius:CGFloat = 4
		layer.cornerRadius = cornerRadius

		let shadowPath = UIBezierPath(rect: bounds)
		layer.masksToBounds = false
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
		layer.shadowOpacity = 0.15
		layer.shadowRadius = 10
		layer.shadowPath = shadowPath.cgPath
	}
}
