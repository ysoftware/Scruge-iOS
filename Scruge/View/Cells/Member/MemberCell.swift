//
//  TeamMember.swift
//  Scruge
//
//  Created by ysoftware on 31/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class MemberCell:UICollectionViewCell {

	@IBOutlet weak var avatarImage:UIImageView!

	@discardableResult
	func setup(with member:Member) -> Self {
		avatarImage.setImage(string: member.imageUrl)
		return self
	}
}
