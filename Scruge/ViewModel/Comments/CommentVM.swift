//
//  CommentVM.swift
//  Scruge
//
//  Created by ysoftware on 26/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import MVVM

final class CommentVM: ViewModel<Comment> {

	var username:String {
		return model?.authorName ?? "Anonymous"
	}

	var profileImageUrl:URL? {
		if let url = model?.authorPhoto {
			return URL(string: url)
		}
		return nil
	}

	var comment:String {
		return model?.text ?? ""
	}

	var date:String {
		guard let model = model else { return "" }
		return Date(milliseconds: model.timestamp).toFormat("d MMM HH:mm")
	}
}
