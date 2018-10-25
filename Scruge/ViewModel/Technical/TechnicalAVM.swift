//
//  TechnicalAVM.swift
//  Scruge
//
//  Created by ysoftware on 25/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class TechnicalAVM: SimpleArrayViewModel<Technical, TechnicalVM> {

	init(_ list:[Technical]) {
		super.init()
		setData(list.map { TechnicalVM($0) })
	}

	override func fetchData(_ block: @escaping (Result<[Technical], AnyError>) -> Void) {
		// no-op
	}
}
