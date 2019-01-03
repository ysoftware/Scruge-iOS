//
//  CommentCell.swift
//  Scruge
//
//  Created by ysoftware on 28/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class CommentCell: UITableViewCell {

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var profileImage: RoundedImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var commentLabel: UILabel!
	@IBOutlet weak var likesLabel: UILabel!
	@IBOutlet weak var replyButton: UIButton!
	@IBOutlet weak var seeAllView: UIStackView!
	@IBOutlet weak var seeAllButton: UIButton!

	private var vm:CommentVM!

	@discardableResult
	func setup(with vm:CommentVM) -> Self {
		self.vm = vm
		usernameLabel.text = vm.authorName
		commentLabel.text = vm.comment
		dateLabel.text = vm.date
		likesLabel.text = vm.likes

		if let imageURL = vm.authorPhoto {
			profileImage.setImage(url: imageURL, hideOnFail: false)
		}
		else {
			profileImage.image = nil
		}

		seeAllButton.setTitle(vm.repliesText, for: .normal)
		seeAllView.isHidden = !vm.canReply
		// TO-DO: ever show reply button?

		return self
	}

	@discardableResult
	func like(_ block: @escaping (CommentVM)->Void) -> Self {
		likeBlock = block
		return self
	}

	@discardableResult
	func seeAll(_ block: @escaping (CommentVM)->Void) -> Self {
		seeAllBlock = block
		return self
	}

	@discardableResult
	func reply(_ block: @escaping (CommentVM)->Void) -> Self {
		replyBlock = block
		return self
	}

	private var likeBlock:((CommentVM)->Void)?
	private var seeAllBlock:((CommentVM)->Void)?
	private var replyBlock:((CommentVM)->Void)?

	@IBAction func likeClicked(_ sender: Any) {
		likeBlock?(vm)
	}

	@IBAction func replyClicked(_ sender: Any) {
		replyBlock?(vm)
	}

	@IBAction func seeAllClicked(_ sender: Any) {
		seeAllBlock?(vm)
	}
}
