//
//  TransparentNavBar.swift
//  Scruge
//
//  Created by ysoftware on 27/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

extension UINavigationBar {

	func makeTransparent() {
		if #available(iOS 11.0, *) {
			prefersLargeTitles = false
		}
		setBackgroundImage(UIImage(), for: .default)
		shadowImage = UIImage()
		tintColor = .white
		topItem?.title = ""
	}

	func makeNormal(with title:String? = nil, tint:UIColor? = nil) {
		setBackgroundImage(nil, for: .default)
		shadowImage = nil

		if let color = tint {
			tintColor = color
		}

		if let title = title {
			topItem?.title = title
		}
	}
}
