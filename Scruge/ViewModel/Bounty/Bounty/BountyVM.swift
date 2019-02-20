//
//  BountyVM.swift
//  Scruge
//
//  Created by ysoftware on 18/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM
import appendAttributedString

final class BountyVM: ViewModel<Bounty> {

	let purple = AttributesBuilder()
		.font(.systemFont(ofSize: 14))
		.color(Service.constants.color.purple)
		.build()

	var id:Int64? {
		return model?.bountyId
	}

	var name:String {
		return model?.bountyName ?? ""
	}

	var description:String {
		return model?.bountyDescription.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
	}

	var rewards:String {
		return model?.rewardsDescription.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
	}

	var rules:String {
		return model?.rulesDescription.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
	}

	var dates:String {
		guard let timestamp = model?.timestamp, let endTimestamp = model?.endTimestamp else { return "" }
		let start = Date.present(timestamp, as: "d MMM yyyy")
		let end = Date.present(endTimestamp, as: "d MMM yyyy")
		return "\(start) - \(end)"
	}

	var shortDescription:NSAttributedString {
		guard let model = model else { return NSAttributedString() }

		if let maxReward = getMaxReward() {
			return maxReward
		}

		return NSMutableAttributedString()
			.append(R.string.localizable.label_bounty_submissions())
			.append(": ")
			.append("\(model.submissions)/\(model.submissionLimit)", withAttributes: purple)
			.lineBreak()

			.append(R.string.localizable.label_bounty_limit_per_user())
			.append(": ")
			.append("\(model.limitPerUser)", withAttributes: purple)
	}

	var longerDescription:NSAttributedString {
		guard let model = model else { return NSAttributedString() }

		let timeLimitDays = model.resubmissionPeriodMilliseconds /  Time.day

		let str = NSMutableAttributedString()

			.append(R.string.localizable.label_bounty_submissions())
			.append(": ")
			.append("\(model.submissions)/\(model.submissionLimit)", withAttributes: purple)
			.lineBreak()

			.append(R.string.localizable.label_bounty_limit_per_user())
			.append(": ")
			.append("\(model.limitPerUser)", withAttributes: purple)
			.lineBreak()

			.append(R.string.localizable.label_bounty_resubmission_period())
			.append(": ")
			.append("\(timeLimitDays) ", withAttributes: purple)
			.append(R.string.localizable.label_days_short_no_plural(), withAttributes: purple)

		getMaxReward().flatMap { str.lineBreak().append($0) }

		return str
	}

	private func getMaxReward() -> NSAttributedString? {
		let gray = AttributesBuilder()
			.font(.systemFont(ofSize: 12))
			.color(Service.constants.color.grayText)
			.build()

		guard let model = model else { return nil }

		if let maxReward = model.maxReward, let totalSupply = model.totalSupply {
			let str = NSMutableAttributedString()
			let array = maxReward.components(separatedBy: " ")

			if array.count == 2,  let amount = Double(array[0]) {
				let percent = (amount / (Double(totalSupply) / 100)).formatDecimal()
				return str
					.append(R.string.localizable.label_bounty_max_reward())
					.append(": ")
					.append(maxReward, withAttributes: purple)
					.whitespace()
					.append(R.string.localizable.label_bounty_percent_of_total_supply(percent),
							withAttributes: gray)
			}
		}
		return nil
	}
}
