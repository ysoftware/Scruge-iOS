//
//  LocalizedString.swift
//  Scruge
//
//  Created by ysoftware on 31/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

public protocol Localizable {

	func localize()
}

public extension Localizable {

	private func localize(_ string: String?) -> String? {
		guard let term = string, term.hasPrefix("@") else {
			return string
		}
		guard !term.hasPrefix("@@") else {
			return String(term.dropFirst())
		}
		return NSLocalizedString(String(term.dropFirst()), comment: "")
	}

	public func localize(_ field:ReferenceWritableKeyPath<Self, String>) {
		self[keyPath: field] = localize(self[keyPath: field]) ?? ""
	}

	public func localize(_ field:ReferenceWritableKeyPath<Self, String?>) {
		self[keyPath: field] = localize(self[keyPath: field])
	}

	public func localize(_ string: String?, _ setter: (String?) -> Void) {
		setter(localize(string))
	}

	public func localize(_ getter: (UIControl.State) -> String?,
						 _ setter: (String?, UIControl.State) -> Void) {
		setter(localize(getter(.normal)), .normal)
		setter(localize(getter(.selected)), .selected)
		setter(localize(getter(.highlighted)), .highlighted)
		setter(localize(getter(.disabled)), .disabled)
	}
}
