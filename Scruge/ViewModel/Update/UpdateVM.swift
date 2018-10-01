//
//  UpdateVM.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class UpdateVM: ViewModel<Update> {

	var imageUrl:String? {
		return model?.imageUrl
	}

	var date:String {
		return "21 October, 2018" // "\(model?.timestamp ?? 0)"
	}

	var title:String {
		return model?.title ?? ""
	}

	var descsription:String {
		return model?.description ?? ""
	}
}
