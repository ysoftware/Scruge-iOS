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

	case voting = "Vooting"

	case fundingInfo = "Funding" // TO-DO: change
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

	// voting

	var votingDate:String {
		return "some date"
	}

	var votingTitle:String {
		return "Campaign's milestone deadline is coming up!"
	}

	var votingDescription:String {
		return "Voting on milestone starts in 3 days on Feb 7th 2019."
	}

	// reply

	var replyDate:String {
		return "some date"
	}

	var replyText:String {
		return (model?.activity as? ActivityReply)?.replyCommentText ?? ""
	}

	var replyAuthorName:String {
		if let name = (model?.activity as? ActivityReply)?.replyUserName {
			if !name.isEmpty { return name }
		}
		return "Anonymous"
	}

	// update

	var updateCampaignTitle:String {
		return (model?.activity as? ActivityUpdate)?.campaign.title ?? ""
			+ " posted an update"
	}

	var updateDescription:String {
		return (model?.activity as? ActivityUpdate)?.update.description ?? ""
	}

	var updateTitle:String {
		return (model?.activity as? ActivityUpdate)?.update.title ?? ""
	}

	var updateDate:String {
		if let time = (model?.activity as? ActivityUpdate)?.update.timestamp {
			return Date.present(time, as: "d MMMM yyyy")
		}
		return ""
	}
}
