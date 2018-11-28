//
//  TransparentNavBar.swift
//  Scruge
//
//  Created by ysoftware on 27/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

extension UINavigationBar {

	@discardableResult
	func preferLarge() -> UINavigationBar {
		if #available(iOS 11.0, *) {
			prefersLargeTitles = true
		}
		return self
	}

	@discardableResult
	func preferSmall() -> UINavigationBar {
		if #available(iOS 11.0, *) {
			prefersLargeTitles = false
		}
		return self
	}

	@discardableResult
	func makeTransparent(keepTitle:Bool = false) -> UINavigationBar {
		setBackgroundImage(UIImage(), for: .default)
		shadowImage = UIImage()
		tintColor = .white
		
		if !keepTitle {
			topItem?.title = ""
		}
		return self
	}

	@discardableResult
	func makeNormal(with title:String? = nil, tint:UIColor? = nil) -> UINavigationBar {
		setBackgroundImage(nil, for: .default)
		shadowImage = nil

		if let color = tint {
			tintColor = color
		}

		topItem?.title = title ?? ""
		return self
	}
}
