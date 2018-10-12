//
//  OtherAVMs.swift
//  Scruge
//
//  Created by ysoftware on 12/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class DocumentAVM: SimpleArrayViewModel<Document, DocumentVM> {

	init(_ list:[Document]) {
		super.init()
		setData(list.map { DocumentVM($0) })
	}

	override func fetchData(_ block: @escaping (Result<[Document], AnyError>) -> Void) {
		// no-op
	}
}
