//
//  TransparentNavBar.swift
//  Scruge
//
//  Created by ysoftware on 27/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

extension UIViewController {

	@discardableResult
	func preferLargeNavbar() -> UIViewController {
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = true
		}
		return self
	}

	@discardableResult
	func preferSmallNavbar() -> UIViewController {
		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = false
		}
		return self
	}

	@discardableResult
	func makeNavbarTransparent(keepTitle:Bool = false) -> UIViewController {
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.tintColor = .white

		if !keepTitle {
			self.navigationItem.title = ""
		}
		return self
	}

	@discardableResult
	func makeNavbarNormal(with title:String? = nil, tint:UIColor? = nil) -> UIViewController {
		navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
		navigationController?.navigationBar.shadowImage = nil
		navigationController?.navigationBar.tintColor = view.tintColor

		if let title = title {
			self.title = title
		}
		return self
	}
}
