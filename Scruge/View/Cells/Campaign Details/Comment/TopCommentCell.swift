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

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var profileImage: RoundedImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var commentLabel: UILabel!
	@IBOutlet weak var likesLabel: UILabel!

	@discardableResult
	func setup(with vm:CommentAVM? = nil) -> Self {
		
		if let vm = vm, vm.numberOfItems > 0 {
			let comment = vm.item(at: 0)

			usernameLabel.text = comment.authorName
			commentLabel.text = comment.comment
			dateLabel.text = comment.date

			if let imageURL = comment.authorPhoto {
				profileImage.setImage(url: imageURL, hideOnFail: false)
			}
			else {
				profileImage.image = nil
			}
		}
		else {
			// no comments

		}
		return self
	}
}
