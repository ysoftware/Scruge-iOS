//
//  CommentVM.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class CommentVM: ViewModel<Comment> {

	var authorName:String {
		return model?.authorName ?? "Anonymous"
	}

	var authorPhoto:URL? {
		if let url = model?.authorAvatar {
			return URL(string: url)
		}
		return nil
	}

	var comment:String {
		return model?.text ?? ""
	}

	var date:String {
		guard let model = model else { return "" }
		return Date.present(model.timestamp, as: "d MMMM, H:mm")
	}

	var likes:String {
		return model?.likeCount.flatMap { "\($0)" } ?? ""
	}

	var id:String { return model?.id ?? "" }

	var canReply:Bool {
		return model?.repliesCount != nil
	}

	var isLiking:Bool {
		return model?.isLiking == true
	}

	var repliesText:String {
		return model?.repliesCount.flatMap { number in
			guard number > 0 else { return "" }
			let replies = number == 1 ? "reply" : "replies"
			return "See \(number) \(replies)"
		} ?? ""
	}

	func like() {
		Service.api.likeComment(self, value: !isLiking) { result in
			if case .success = result {
				self.notifyUpdated()
			}
		}
	}
}
