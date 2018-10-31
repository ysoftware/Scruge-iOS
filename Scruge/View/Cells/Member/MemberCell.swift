//
//  TeamMember.swift
//  Scruge
//
//  Created by ysoftware on 31/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class MemberCell:UITableViewCell {

	@IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!

	@IBOutlet weak var collectionView:UICollectionView!
	@IBOutlet weak var nameLabel:UILabel!
	@IBOutlet weak var descriptionLabel:UILabel!
	@IBOutlet weak var positionLabel:UILabel!
	@IBOutlet weak var avatarImage:UIImageView!

	var social:[Social] = []
	var block:((Social)->Void)?

	@discardableResult
	func setup(with member:Member, _ block: ((Social)->Void)?) -> Self {
		social = member.social
		self.block = block

		nameLabel.text = member.name
		descriptionLabel.text = member.description
		positionLabel.text = member.position
		avatarImage.setImage(string: member.imageUrl)

		collectionView.register(UINib(resource: R.nib.socialCell),
								forCellWithReuseIdentifier: R.nib.socialCell.identifier)
		collectionView.isHidden = social.count == 0
		collectionView.reloadData()
		return self
	}
}

extension MemberCell: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return social.count
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.socialCell,
												  for: indexPath)!
			.setup(with: social[indexPath.item])
	}
}

extension MemberCell: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		block?(social[indexPath.item])
	}
}
