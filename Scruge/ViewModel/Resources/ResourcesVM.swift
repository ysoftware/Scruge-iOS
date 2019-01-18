//
//  ResourcesVM.swift
//  Scruge
//
//  Created by ysoftware on 17/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM

final class ResourcesVM: ViewModel<Resources> {

	var accountName:String?

	func load() {
		guard let accountName = accountName?.eosName else {
			model = nil
			return notifyUpdated()
		}

		Service.eos.getResources(of: accountName) { result in
			self.model = result.value
			self.notifyUpdated()
		}
	}

	private var data:Account? { return model?.data }

	// strings

	var cpuWeight:String { return data?.totalResources.cpuWeight ?? "" }

	var netWeight:String { return data?.totalResources.netWeight ?? "" }

	var cpu:String { return "\(cpuUsedValue.formatRounding(separateWith: "."))ms / \(cpuLimitValue.formatRounding(separateWith: "."))ms" }

	var net:String { return "\(netUsedValue.formatRounding(separateWith: "."))KB / \(netLimitValue.formatRounding(separateWith: "."))KB" }

	var ram:String { return "\(ramUsedValue)KB / \(ramLimitValue)KB" }

	// values

	var cpuLimitValue:Double { return Double(data?.cpuLimit?.max ?? 0) / 1000 }

	var cpuUsedValue: Double { return Double(data?.cpuLimit?.used ?? 0) / 1000 }

	var netLimitValue: Double { return Double(data?.netLimit?.max ?? 0) / 1000 }

	var netUsedValue: Double { return Double(data?.netLimit?.used ?? 0) / 1000 }

	var ramLimitValue: Double { return Double(data?.ramQuota ?? 0) / 1000 }

	var ramUsedValue: Double { return Double(data?.ramUsage ?? 0) / 1000 }
}
