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
		if let name = model?.authorName {
			if !name.isEmpty { return name }
		}
		return R.string.localizable.label_anonymous()
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
		return model.flatMap { "\($0.likeCount)" } ?? ""
	}

	var id:String { return model?.id ?? "" }

	var canReply:Bool {
		return model?.repliesCount != nil
	}

	var isLiking:Bool {
		return model?.isLiking == true
	}

	// TO-DO: plurals

	var repliesText:String? {
		return model?.repliesCount.flatMap { number in
			guard number > 0 else { return nil }
			let replies = number == 1 ? "reply" : "replies"
			return "See \(number) \(replies)"
		}
	}

	func like() {
		guard let model = model else { return }
		let newValue = !isLiking
		Service.api.likeComment(model, value: newValue) { result in
			if case .success(let response) = result {
				if ErrorHandler.error(from: response.result) == nil {
					self.model?.likeCount = model.likeCount + (newValue ? 1 : -1)
					self.model?.isLiking = newValue
					self.notifyUpdated()
				}
			}
		}
	}
}
