//
//  CommentCell.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import Kingfisher

final class TopCommentCell: UITableViewCell {

	@IBOutlet weak var topCommentStack: UIStackView!
	@IBOutlet weak var noCommentsStack: UIStackView!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var profileImage: RoundedImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var commentLabel: UILabel!
	@IBOutlet weak var likesLabel: UILabel!
	@IBOutlet weak var allCommentsStack: UIStackView!
	@IBOutlet weak var allCommentsLabel: UILabel!

	@discardableResult
	func setup(with vm:CommentAVM? = nil, allCommentsCount:Int) -> Self {
		
		if let vm = vm, !vm.isEmpty {
			let comment = vm.item(at: 0)

			usernameLabel.text = comment.authorName
			commentLabel.text = comment.comment
			dateLabel.text = comment.date
			likesLabel.text = comment.likes

			if let imageURL = comment.authorPhoto {
				profileImage.setImage(url: imageURL, hideOnFail: false)
			}
			else {
				profileImage.image = nil
			}

			if allCommentsCount == 1 {
				allCommentsLabel.text = "Add your comment"
			}
			else {
				allCommentsLabel.text = "See all \(allCommentsCount) comments"
			}
			noCommentsStack.isHidden = true
			topCommentStack.isHidden = false
		}
		else {
			allCommentsLabel.text = "Add your comment"
			noCommentsStack.isHidden = false
			topCommentStack.isHidden = true
		}
		return self
	}

	private var tapBlock:(()->Void)!

	@discardableResult
	func allComments(_ tap: @escaping ()->Void) -> TopCommentCell {
		tapBlock = tap
		let tap = UITapGestureRecognizer(target: self, action: #selector(openAll))
		allCommentsStack.gestureRecognizers = [tap]
		return self
	}

	@objc func openAll() {
		tapBlock?()
	}
}
