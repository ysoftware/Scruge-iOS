//
//  ProducerVM.swift
//  Scruge
//
//  Created by ysoftware on 07/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM

final class ProducerVM: ViewModel<Producer>, Hashable {

	convenience init(_ model:Producer, _ totalWeight:String) {
		self.init(model)
		self.totalVotesWeight = totalWeight
	}

	var totalVotesWeight:String?

	var name:String {
		return model?.owner ?? ""
	}

	var votes:String {
		guard let weightString = model?.totalVotes, let totalString = totalVotesWeight,
		let weight = Double(weightString), let total = Double(totalString) else { return "" }
		let percent = (weight / (total / 100)).formatRounding()
		return percent + "%"
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(model?.owner.hashValue ?? 0)
	}
}
