//
//  AccountModel.swift
//  Scruge
//
//  Created by ysoftware on 19/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

struct AccountModel: Equatable {

	let name:String

	let wallet:SELocalAccount
}

extension AccountModel: Comparable {

	static func < (lhs: AccountModel, rhs: AccountModel) -> Bool {
		return lhs.name < rhs.name
	}
}
