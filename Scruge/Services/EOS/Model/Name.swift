//
//  Name.swift
//  Scruge
//
//  Created by ysoftware on 18/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation

struct EosName:Equatable, Hashable {

	let string:String

	/// for use only with hardcoded strings
	static func create(_ name:String) -> EosName {
		return EosName(from: name)!
	}

	init?(from string:String) {
		if (string.isValidEosName) {
			self.string = string
		}
		else {
			return nil
		}
	}
}

extension String {

	var eosName:EosName? { return EosName(from: self) }

	var isValidEosName:Bool {

		if count > 12 || count == 0 || self == "." {
			return false
		}

		let charPool = ".12345abcdefghijklmnopqrstuvwxyz"
		for s in self {
			if (!charPool.contains(s)) {
				return false
			}
		}

		return true
	}
}
