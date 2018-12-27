//
//  TransactionVM.swift
//  Scruge
//
//  Created by ysoftware on 27/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class ActionVM: ViewModel<ActionReceipt> {

	
}

extension ActionReceipt: Equatable {
	static func == (lhs: ActionReceipt, rhs: ActionReceipt) -> Bool {
		return lhs.globalActionSeq == rhs.globalActionSeq
	}
}
