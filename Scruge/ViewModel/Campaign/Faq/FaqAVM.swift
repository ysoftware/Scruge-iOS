//
//  OtherAVMs.swift
//  Scruge
//
//  Created by ysoftware on 12/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class FaqAVM: SimpleArrayViewModel<Faq, FaqVM> {

	init(_ list:[Faq]) {
		super.init()
		setData(list.map { FaqVM($0) })
	}

	override func fetchData(_ block: @escaping (Result<[Faq], AnyError>) -> Void) {
		// no-op
	}
}
