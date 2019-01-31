//
//  BlankString.swift
//  Scruge
//
//  Created by ysoftware on 31/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation

extension String {

	var isBlank:Bool {
		return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}

	var isNotBlank:Bool {
		return !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}

	var isNotEmpty:Bool {
		return !isEmpty
	}
}
