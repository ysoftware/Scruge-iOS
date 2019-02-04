//
//  LocalizableViews.swift
//  Scruge
//
//  Created by ysoftware on 31/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

extension UIView: Localizable {

	public func localize() {

		if let label = self as? UILabel {
			label.localize(\.text)
		}
		else if let button = self as? UIButton {
			localize(button.title(for:), button.setTitle(_:for:))
		}
		else if let button = self as? Button {
			button.localize(\.text)
		}
		else if let field = self as? UITextField {
			field.localize(\.text)
			field.localize(\.placeholder)
		}
		else {
			subviews.forEach { $0.localize() }
		}
		layoutIfNeeded()
	}
}

extension UIBarItem: Localizable {

	public func localize() {
		if let barButtonItem = self as? UIBarButtonItem {
			barButtonItem.customView?.localize()
		}
		else {
			localize(title) { title = $0 }
		}
	}
}

extension UINavigationItem: Localizable {

	public func localize() {
		localize(title) { title = $0 }
		localize(prompt) { prompt = $0 }
		titleView?.localize()
		leftBarButtonItems?.forEach { $0.localize() }
		rightBarButtonItems?.forEach { $0.localize() }
	}
}

extension UIViewController: Localizable {

	public func localize() {
		localize(title) { title = $0 }
		navigationItem.localize()
		tabBarItem?.localize()
		view.localize()
	}
}
