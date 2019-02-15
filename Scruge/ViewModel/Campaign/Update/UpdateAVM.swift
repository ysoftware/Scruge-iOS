//
//  UpdateAVM.swift
//  Scruge
//
//  Created by ysoftware on 25/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import Result

final class UpdateAVM: SimpleArrayViewModel<Update, UpdateVM> {

	enum Source {

		case campaign(Campaign)
	}

	private let source:Source

	init(_ source:Source) {
		self.source = source
	}

	init(_ updates:[Update], for campaign:Campaign) {
		self.source = .campaign(campaign)
		super.init()
		setData(updates.map { UpdateVM($0) })
	}

	override func fetchData(_ block: @escaping (Result<[Update], AnyError>) -> Void) {
		switch source {
		case .campaign(let campaign):
			Service.api.getUpdateList(for: campaign) { block($0.map { $0.updates }) }
		}
	}
}
