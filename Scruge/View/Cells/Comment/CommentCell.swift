//
//  CommentCell.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import Kingfisher

final class CommentCell: UITableViewCell {

	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var profileImage: RoundedImageView!
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var commentLabel: UILabel!

	@discardableResult
	func setup(with vm:CommentVM) -> Self {
		usernameLabel.text = vm.authorName
		commentLabel.text = vm.comment
		dateLabel.text = vm.date

		if let url = vm.authorPhoto {
			profileImage.kf.setImage(with: url)
		}
		return self
	}
}
