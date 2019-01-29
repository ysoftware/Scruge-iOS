//
//  ActivityAVM.swift
//  Scruge
//
//  Created by ysoftware on 16/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class ActivityAVM: ArrayViewModel<ActivityHolder, ActivityVM, ActivityQ> {

	override func fetchData(_ query: ActivityQ?,
							_ block: @escaping (Result<[ActivityHolder], AnyError>) -> Void) {
		Service.api.getActivity(query: query) { result in block(result.map { $0.activity }) }
	}
}
