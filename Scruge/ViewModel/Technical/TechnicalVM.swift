//
//  TechnicalVM.swift
//  Scruge
//
//  Created by ysoftware on 25/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class TechnicalVM: ViewModel<Technical> {

	var name:String {
		return model?.name ?? ""
	}

	var value:String {
		return model?.value ?? ""
	}
}
