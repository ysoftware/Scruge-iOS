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

	private let purple = Service.constants.color.purple
	private let green = Service.constants.color.green
	private let grayLight = Service.constants.color.grayLight
	private let grayText = Service.constants.color.grayText
	private let gray = Service.constants.color.gray

	// hax, there should be a method to set up vm inside avm
	var accountName:String? { return (arrayDelegate as? ActionsAVM)?.accountName.string }

	var time:String {
		guard let model = model, let date = Date.init(model.blockTime) else { return "" }
		return Date.present(date.milliseconds, as: "d/MM/yy HH:mm")
	}

	var actionName:NSAttributedString {
		guard let model = model else { return NSAttributedString() }
		let font = UIFont.systemFont(ofSize: 14)
		let str = NSMutableAttributedString()

		let type = ActionType.from(model.actionTrace.act, accountName: accountName)
		switch type {
		case .sent:
			str.append(R.string.localizable.transaction_sent(), color: purple, font: font)
		case .invested:
			str.append(R.string.localizable.transaction_invested(), color: purple, font: font)
		case .received:
			str.append(R.string.localizable.transaction_received(), color: green, font: font)
		case .voted:
			str.append(R.string.localizable.transaction_voted(), color: green, font: font)
		case .transfer:
			str.append(R.string.localizable.transaction_transfer(), color: grayText, font: font)
		case .other(let action):
			str.append(action.account, color: grayText, font: .systemFont(ofSize: 14, weight: .semibold))
				.append(" -> ", color: grayText, font: font)
				.append(action.name, color: grayText, font: font)
		}
		return str
	}

	// description + details
	var actionDetails:NSAttributedString {
		guard let model = model else { return NSAttributedString() }
		let font = UIFont.systemFont(ofSize: 14)
		let str = NSMutableAttributedString()

		let type = ActionType.from(model.actionTrace.act, accountName: accountName)
		switch type {
		case .sent(let transfer):
			str.append("\(transfer.quantity) to \(transfer.to)", color: grayText, font: font)
			if (!transfer.memo.isEmpty) {
				str.append("\n\(transfer.memo)", color: gray, font: .systemFont(ofSize: 12))
			}
		case .invested(let campaignTitle, let amount):
			str.append("\(amount) in \(campaignTitle)", color: grayText, font: font)
		case .received(let transfer):
			str.append("\(transfer.quantity) from \(transfer.from)", color: grayText, font: font)
			if (!transfer.memo.isEmpty) {
				str.append("\n\(transfer.memo)", color: gray, font: .systemFont(ofSize: 12))
			}
		case .voted(let campaignTitle, let voteKind):
			let kind = voteKind == .extend
				? R.string.localizable.label_voting_to_extend()
				: R.string.localizable.label_voting_to_release_funds()

			str.append(R.string.localizable.label_voting_participated(kind, campaignTitle),
				color: grayText, font: font)
		case .transfer(let transfer):
			str.append("\(transfer.from)", color: grayText, font: font)
				.append(" -> ", color: gray, font: font)
				.append("\(transfer.to): ", color: grayText, font: font)
				.append("\(transfer.quantity)", color: grayText, font: font)
			if (!transfer.memo.isEmpty) {
				str.append("\n\(transfer.memo)", color: gray, font: .systemFont(ofSize: 12))
			}
		case .other(let action):
			str.append("\(action.data)", color: gray, font: .systemFont(ofSize: 12))
		}
		 
		return str
	}
}

extension ActionDetails {

	var transferData: Transfer? {
		return data.toDictionary().parse(object: Transfer.self)
	}
}

extension ActionReceipt: Equatable {
	static func == (lhs: ActionReceipt, rhs: ActionReceipt) -> Bool {
		return lhs.globalActionSeq == rhs.globalActionSeq
	}
}

enum ActionType {

	case sent(Transfer),

	received(Transfer),

	transfer(Transfer),

	invested(campaignTitle:String, amount:String),

	voted(campaignTitle:String, voteKind:VoteKind),

	other(ActionDetails)

	static func from(_ action:ActionDetails, accountName:String?) -> ActionType {
		if action.name == "transfer", let data = action.transferData {
			if accountName == data.from {
				if data.to == Service.eos.contractAccount.string {
					return .invested(campaignTitle: "-campaign-", amount: data.quantity) // todo
				}
				return .sent(data)
			}
			else if accountName == data.to {
				return .received(data)
			}
			return .transfer(data)
		}
		else if action.name == "vote", action.account == Service.eos.contractAccount.string {
			return .voted(campaignTitle: "-campaign-", voteKind: .extend) // todo
		}
		return .other(action)
	}
}
