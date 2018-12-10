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
		return Date.present(model.timestamp, as: "d MMMM yyyy")
	}

	var title:String {
		return model?.title ?? ""
	}

	var descsription:String {
		return model?.description ?? ""
	}

	// MARK: - Campaign Info (for Activity)

	var campaignId:Int {
		return model?.campaignInfo?.id ?? 0
	}

	var campaignTitle:String {
		return model?.campaignInfo?.title ?? ""
	}

	var campaignImageUrl:String? {
		return model?.campaignInfo?.imageUrl
	}

	// MARK: - Actions

	func loadDescription(_ completion: @escaping (String)->Void) {
		guard let model = model else { return completion("") }
		Service.api.getUpdateContent(for: model) { result in
			if case let .success(response) = result {
				completion(response.content)
			}
			else {
				completion("")
			}
		}
	}
}
