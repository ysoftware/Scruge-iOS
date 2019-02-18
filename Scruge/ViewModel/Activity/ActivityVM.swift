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

	case fundingInfo = "CampFundingEnd"

	case votingResults = "VotingResult"

	case submission = "Submission"

	case submissionPaid = "SubmissionPaid"
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
		case .votingResults: return R.image.star()!
		case .fundingInfo: return R.image.checkmark()!

		case .submission: return R.image.checkmark()!
		case .submissionPaid: return R.image.star()!
		}
	}

	var color:UIColor {
		switch type {
		case .update: return Service.constants.color.green
		case .reply: return Service.constants.color.purple
		case .voting: return Service.constants.color.green
		case .votingResults: return Service.constants.color.purple
		case .fundingInfo: return Service.constants.color.purple

		case .submission: return Service.constants.color.purple
		case .submissionPaid: return Service.constants.color.green
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
		let name = (model?.activity as? ActivityReply).flatMap {
			!$0.replyUserName.isEmpty ? $0.replyUserName : nil } ?? R.string.localizable.label_anonymous()
		return R.string.localizable.label_replied_to_your_comment(name)
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

	var updateActivity:String? {
		return (model?.activity as? ActivityUpdate).flatMap {
			R.string.localizable.label_posted_update($0.campaign.title) } ?? ""
	}

	// funding result

	var fundingDate:String {
		return (model?.activity as? ActivityFunding).flatMap {
			Date.present($0.timestamp, as: "d MMMM HH:mm") } ?? ""
	}

	var fundingTitle:String {
		return (model?.activity as? ActivityFunding).flatMap {
			R.string.localizable.label_finished_funding_campaign($0.campaign.title) } ?? ""
	}

	var fundingDescription:String {
		return (model?.activity as? ActivityFunding).flatMap {
			let cap = $0.softCap.formatDecimal(separateWith: " ")
			let s = R.string.localizable.label_reached_goal_of($0.campaign.title, cap)
			let f = R.string.localizable.label_did_not_reach_goal_of($0.campaign.title, cap)
			return $0.raised >= $0.softCap ? s : f
		} ?? ""
	}

	// submission

	// todo change and localize

	var submissionDate:String {
		return (model?.activity as? ActivitySubmission).flatMap {
			Date.present($0.timestamp, as: "d MMMM HH:mm") } ?? ""
	}

	var submissionTitle:String {
		return (model?.activity as? ActivitySubmission).flatMap {
			"\($0.projectName): \($0.bountyName)" } ?? ""
	}

	var submissionDetails:String {
		return R.string.localizable.label_you_have_submitted_for_bounty()
	}

	// submission paid

	// todo change and localize

	var submissionPaidDate:String {
		return (model?.activity as? ActivitySubmissionPaid).flatMap {
			Date.present($0.timestamp, as: "d MMMM HH:mm") } ?? ""
	}

	var submissionPaidTitle:String {
		return (model?.activity as? ActivitySubmission).flatMap {
			"\($0.projectName): \($0.bountyName)" } ?? ""
	}

	var submissionPaidDetails:String {
		guard let m = model?.activity as? ActivitySubmissionPaid,
			let paid = m.paid ?? m.paidEOS else { return "" }
		return R.string.localizable.label_you_were_paid_x_for_bounty(paid)
	}

	// voting

	/// date of the notification
	var votingDate:String {
		return (model?.activity as? ActivityVoting).flatMap {
			Date.present($0.timestamp, as: "d MMMM HH:mm") } ?? ""
	}

	var votingTitle:String {
		return (model?.activity as? ActivityVoting).flatMap {
			R.string.localizable.label_voting_in_starts_soon($0.campaign.title) } ?? ""
	}

	var votingDescription:String {
		return (model?.activity as? ActivityVoting)
			.flatMap { a in
				let date = Date.present(a.startTimestamp, as: "d MMMM")
				let time = Date.present(a.startTimestamp, as: "HH:mm")
				let period = "\(a.noticePeriodSec / (24*60*60))"

				let type = VoteKind(rawValue:a.kind) == .extend
					? R.string.localizable.label_voting_to_extend()
					: R.string.localizable.label_voting_to_release_funds()

				return R.string.localizable
					.label_voting_to_of_for_starts_in_on_at(type, a.milestoneTitle, a.campaign.title,
															period, date, time)
			} ?? ""
	}

	// voting result

	/// date of the notification
	var votingResultDate:String {
		return (model?.activity as? ActivityVotingResult).flatMap {
			Date.present($0.timestamp, as: "d MMMM HH:mm") } ?? ""
	}

	var votingResultTitle:String {
		return (model?.activity as? ActivityVotingResult).flatMap {
			R.string.localizable.label_voting_in_has_finished($0.campaign.title) } ?? ""
	}

	var votingResultDescription:String {
		return (model?.activity as? ActivityVotingResult)
			.flatMap { a in

				let type = VoteKind(rawValue:a.kind) == .extend
					? R.string.localizable.label_voting_to_extend()
					: R.string.localizable.label_voting_to_release_funds()

				return R.string.localizable.label_voting_to_of_for_has_finished(type,
																				a.milestoneTitle, a.campaign.title)
			} ?? ""
	}

	// other

	var updateVM:UpdateVM? {
		return (model?.activity as? ActivityUpdate).flatMap { UpdateVM($0.update) }
	}

	var replyId:String? {
		return (model?.activity as? ActivityReply)?.parentCommentId
	}

	var campaignId:Int? {
		let m = model?.activity
		return (m as? ActivityUpdate)?.campaign.id ?? (m as? ActivityVoting)?.campaign.id
			?? (m as? ActivityFunding)?.campaign.id ?? (m as? ActivityVotingResult)?.campaign.id
	}
}

