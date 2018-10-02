//
//  UpdateVM.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import SwiftDate

final class UpdateVM: ViewModel<Update> {

	var imageUrl:String? {
		return model?.imageUrl
	}

	var date:String {
		guard let model = model else { return "" }
		return Date(milliseconds: model.timestamp).toFormat("d MMMM")
	}

	var title:String {
		return model?.title ?? ""
	}

	var descsription:String {
		return model?.description ?? ""
	}
}
