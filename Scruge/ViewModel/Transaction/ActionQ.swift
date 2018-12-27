//
//  TransactionQ.swift
//  Scruge
//
//  Created by ysoftware on 27/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class ActionsQuery:MVVM.Query {

	var position:Int = -1

	var offset:Int = -21

	var size: UInt = 20

	func resetPosition() {
		position = -1
		offset = -21
	}

	func advance() {
		position -= 20
		offset -= 20
	}
}
