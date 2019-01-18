//
//  Distinct.swift
//  Scruge
//
//  Created by ysoftware on 18/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import Foundation

extension Array where Element : Hashable {
	var distinct: [Element] {
		return Array(Set(self))
	}
}
