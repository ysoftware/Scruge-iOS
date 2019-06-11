//
//  TransactionAVM.swift
//  Scruge
//
//  Created by ysoftware on 27/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM


final class ActionsAVM: ArrayViewModel<ActionReceipt, ActionVM, ActionsQuery> {

	let accountName:EosName

	init(accountName:EosName) {
		self.accountName = accountName
	}

	override func fetchData(_ query: ActionsQuery?,
							_ block: @escaping (Result<[ActionReceipt], Error>) -> Void) {
		Service.eos.getActions(for: accountName, query: query, completion: block)
	}
}
