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

		// TO-DO: remove this
		append(FaqVM(Faq(question: "How long will this go for?", answer: "We don't know yet but probably for a very long time.")))

		append(FaqVM(Faq(question: "How long will this go for?", answer: "We don't know yet but probably for a very long time.")))

		append(FaqVM(Faq(question: "How long will this go for?", answer: "We don't know yet but probably for a very long time.")))

		append(FaqVM(Faq(question: "How long will this go for?", answer: "We don't know yet but probably for a very long time.")))


	}

	override func fetchData(_ block: @escaping (Result<[Faq], AnyError>) -> Void) {
		// no-op
	}
}
