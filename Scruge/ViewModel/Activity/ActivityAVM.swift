//
//  ActivityAVM.swift
//  Scruge
//
//  Created by ysoftware on 16/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM


final class ActivityAVM: ArrayViewModel<ActivityHolder, ActivityVM, ActivityQ> {

	override func fetchData(_ query: ActivityQ?,
							_ block: @escaping (Result<[ActivityHolder], Error>) -> Void) {
		Service.api.getActivity(query: query) { block($0.map { $0.activity }) }
	}
}
