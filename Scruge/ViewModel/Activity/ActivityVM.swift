//
//  ActivityVM.swift
//  Scruge
//
//  Created by ysoftware on 16/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import MVVM

enum ActivityType:String {

	case reply = "Reply"

	case update = "Update"

	case voting = "Voting"

	case fundingInfo = "CampFundingEnd" // TO-DO: change
}

final class ActivityVM: ViewModel<ActivityHolder> {

	var type:ActivityType {
		return model.flatMap { ActivityType(rawValue: $0.activity.type) } ?? .update
	}

	// general

	var icon:UIImage {
		switch type {
		case .update: return R.image.checkmark()!
		case .reply: return R.image.comment()!
		case .voting: return R.image.star()!
		case .fundingInfo: return R.image.checkmark()!
		}
	}

	var color:UIColor {
		switch type {
		case .update: return Service.constants.color.green
		case .reply: return Service.constants.color.purple
		case .voting: return Service.constants.color.green
		case .fundingInfo: return Service.constants.color.purple
		}
	}

	// reply

	var replyDate:String {
		return (model?.activity as? ActivityReply).flatMap {
			Date.present($0.timestamp, as: "d MMMM HH:mm") } ?? ""
	}

	var replyText:String {
		return (model?.activity as? ActivityReply)?.replyCommentText ?? ""
	}

	var replyAuthorName:String {
		return (model?.activity as? ActivityReply)
			.flatMap { !$0.replyUserName.isEmpty ? $0.replyUserName : nil } ?? "Anonymous"
				+ " replied to your comment"
	}

	// update

	var updateTitle:String {
		return (model?.activity as? ActivityUpdate)?.update.title ?? ""
	}

	var updateDate:String {
		return (model?.activity as? ActivityUpdate).flatMap {
			Date.present($0.update.timestamp, as: "d MMMM HH:mm") } ?? ""
	}

	var updateDescription:String {
		return (model?.activity as? ActivityUpdate)?.update.description ?? ""
	}

	var updateImage:String {
		return (model?.activity as? ActivityUpdate)?.update.imageUrl ?? ""
	}

	var updateActivity:NSAttributedString? {
		let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		return (model?.activity as? ActivityUpdate).flatMap {
			NSMutableAttributedString()
				.append($0.campaign.title, color: Service.constants.color.purple, font: font)
				.append(" posted an update", color: Service.constants.color.grayTitle, font: font)
		}
	}

	// funding result

	var fundingDate:String { // TO-DO:
		return "some date"
	}

	var fundingTitle:String { // TO-DO:
		return (model?.activity as? ActivityFunding).flatMap {
			"\($0.campaign.title) has finished its funding campaign" } ?? ""
	}

	var fundingDescription:String { // TO-DO:
		return (model?.activity as? ActivityFunding).flatMap {
			let cap = $0.softCap.formatDecimal(separateWith: " ")
			let s = "\($0.campaign.title) has successfully reached the goal of $\(cap)."
			let f = "Campaign did not reach the minimum goal of $\(cap) and is now closed."
			return $0.raised >= $0.softCap ? s : f
		} ?? ""
	}

	// voting

	/// date of the notification
	var votingDate:String { // TO-DO:
		return (model?.activity as? ActivityVoting).flatMap { // TO-DO
			Date.present($0.startTimestamp - $0.noticePeriodSec, as: "")
		} ?? ""
	}

	var votingTitle:String { // TO-DO:
		return (model?.activity as? ActivityVoting)
			.flatMap { a in
				let type = VoteKind(rawValue:a.kind) == .extend ? "extend deadline" : "release funds"
				return "Voting on \(type) for \(a.campaign.title) starts soon" } ?? ""
	}

	var votingDescription:String { // TO-DO:
		return (model?.activity as? ActivityVoting)
			.flatMap { a in
				let date = Date.present(a.startTimestamp, as: "d MMMM")
				let time = Date.present(a.startTimestamp, as: "HH:mm")
				let period = a.noticePeriodSec / (24*60*60)
				let type = VoteKind(rawValue:a.kind) == .extend ? "extend deadline" : "release funds"
				return "Voting to \(type) of milestone \(a.milestoneTitle) for campaign \(a.campaign.title) starts in \(period) days on \(date) at \(time)"
			} ?? ""
	}

	// voting result

	/// date of the notification
	var votingResultDate:String { // TO-DO:
		return "some date"
	}

	var votingResultTitle:String { // TO-DO:
		return (model?.activity as? ActivityVoting)
			.flatMap { a in
				let type = VoteKind(rawValue:a.kind) == .extend ? "extend deadline" : "releas funds"
				return "Vote for \(a.campaign.title) on \(type) has finished" } ?? ""
	}

	var votingResultDescription:String { // TO-DO:
		return "Voting on milestone starts in 3 days on Feb 7th 2019."
	}

	// other

	var updateVM:UpdateVM? {
		return (model?.activity as? ActivityUpdate).flatMap { UpdateVM($0.update) }
	}

	var replyId:String? {
		return nil // (model as? ActivityReply)?.reply
	}

	var campaignId:Int? {
		let m = model?.activity
		return (m as? ActivityUpdate)?.campaign.id ?? (m as? ActivityVoting)?.campaign.id
			?? (m as? ActivityFunding)?.campaign.id ?? (m as? ActivityVotingResult)?.campaign.id
	}
}

