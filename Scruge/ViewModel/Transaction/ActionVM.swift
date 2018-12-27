//
//  TransactionVM.swift
//  Scruge
//
//  Created by ysoftware on 27/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM
import appendAttributedString

final class ActionVM: ViewModel<ActionReceipt> {

	// hax, there should be a method to set up vm inside avm
	var accountName:String? { return (arrayDelegate as? ActionsAVM)?.accountName }

	var actionName:NSAttributedString {
		guard let model = model else { return NSAttributedString() }
		let font = UIFont.systemFont(ofSize: 14)
		let str = NSMutableAttributedString()
		let name = model.actionTrace.act.name

		if name == "transfer", let data = model.actionTrace.act.transferData {
			if accountName == data.from {
				str.append("Sent", color: Service.constants.color.purple, font: font)
			}
			else if accountName == data.to {
				str.append("Received", color: Service.constants.color.green, font: font)
			}
			else {
				str.append("Transfer", color: Service.constants.color.grayText, font: font)
			}
		}
		else {
			str.append(name, color: Service.constants.color.grayText, font: font)
		}
		return str
	}

	var time:String {
		guard let model = model, let date = Date.init(model.blockTime) else { return "" }
		return Date.present(date.milliseconds, as: "d/MM/yy HH:mm")
	}

	var actionDetails:NSAttributedString {
		guard let model = model else { return NSAttributedString() }
		let font = UIFont.systemFont(ofSize: 14)
		let str = NSMutableAttributedString()
		let name = model.actionTrace.act.name

		if name == "transfer", let data = model.actionTrace.act.transferData {
			if accountName == data.from {
				str.append("\(data.quantity) to \(data.to)",
					color: Service.constants.color.grayText, font: font)
			}
			else if accountName == data.to {
				str.append("\(data.quantity) from \(data.from)",
						   color: Service.constants.color.grayText, font: font)
			}
			else {
				str.append("\(data.to) -> \(data.from): \(data.quantity)",
					color: Service.constants.color.grayText, font: font)
			}
		}
		else {
			str.append("\(model.actionTrace.act.account)",
				color: Service.constants.color.grayText, font: font)
		}
		return str
	}
}

extension ActionDetails {

	var transferData: Transfer? {
		return data.parse(object: Transfer.self)
	}
}

extension ActionReceipt: Equatable {
	static func == (lhs: ActionReceipt, rhs: ActionReceipt) -> Bool {
		return lhs.globalActionSeq == rhs.globalActionSeq
	}
}
