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
		return model?.likesCount.flatMap { "\($0)" } ?? ""
	}
}
