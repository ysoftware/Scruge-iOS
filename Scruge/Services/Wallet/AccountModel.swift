//
//  Model.swift
//  
//
//  Created by ysoftware on 14/12/2018.
//

import Foundation

struct AccountModel: Equatable, Comparable {

	let name:String

	let wallet:SELocalAccount

	static func < (lhs: AccountModel, rhs: AccountModel) -> Bool {
		return lhs.name < rhs.name
	}
}
