//
//  TransactionAVM.swift
//  Scruge
//
//  Created by ysoftware on 27/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class ActionsAVM: ArrayViewModel<ActionReceipt, ActionVM, ActionsQuery> {

	private let accountName:String

	init(accountName:String) {
		self.accountName = accountName
	}

	override func fetchData(_ query: ActionsQuery?,
							_ block: @escaping (Result<[ActionReceipt], AnyError>) -> Void) {
		Service.eos.getActions(for: accountName, query: query, completion: block)
	}
}
