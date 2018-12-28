//
//  TransactionQ.swift
//  Scruge
//
//  Created by ysoftware on 27/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

/// trying to match the weird pagination system used in get_actions rpc call
final class ActionsQuery:MVVM.Query {

	var position:Int = -1

	var offset:Int = -1

	var size: UInt = 1

	func set(limit: Int) {
		position = limit + 49
	}

	func resetPosition() {
		position = -1
		offset = -1
		size = 1
	}

	func advance() {
		if position != -1 {
			size = 50
			offset = -50
			position = max(0, position - Int(size))
		}
	}
}
