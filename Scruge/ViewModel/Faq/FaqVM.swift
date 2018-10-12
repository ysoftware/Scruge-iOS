//
//  OtherVMs.swift
//  Scruge
//
//  Created by ysoftware on 12/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class FaqVM: ViewModel<Faq> {

	var question: String {
		return model?.question ?? ""
	}

	var answer: String {
		return model?.answer ?? ""
	}
}
