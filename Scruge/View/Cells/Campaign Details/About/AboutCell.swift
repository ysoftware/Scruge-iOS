//
//  SocialCell.swift
//  Scruge
//
//  Created by ysoftware on 11/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class AboutCell: UITableViewCell {

	@IBOutlet weak var membersCollectionViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
	@IBOutlet weak var collectionView:UICollectionView!
	@IBOutlet weak var membersCollectionView: UICollectionView!
	@IBOutlet weak var aboutLabel:UILabel!
	
	var social:[Social] = []
	var block:((Social)->Void)?

	var members:[Member] = []
	var memberBlock:((Member)->Void)?

	@discardableResult
	func socialTap(_ tap: @escaping (Social)->Void) -> Self {
		self.block = tap
		return self
	}

	@discardableResult
	func memberTap(_ tap: @escaping (Member)->Void) -> Self {
		self.memberBlock = tap
		return self
	}

	@discardableResult
	func setup(with vm:CampaignVM) -> Self {
		social = vm.social
		members = vm.team

		aboutLabel.text = vm.about
		collectionView.register(UINib(resource: R.nib.socialCell),
								forCellWithReuseIdentifier: R.nib.socialCell.identifier)
		membersCollectionView.register(UINib(resource: R.nib.memberCell),
								forCellWithReuseIdentifier: R.nib.memberCell.identifier)

		collectionView.isHidden = social.count == 0
		membersCollectionView.isHidden = members.count == 0

		collectionView.reloadData()
		membersCollectionView.reloadData()

		collectionHeightConstraint.constant = social.count > 0 ? 35 : 0
		membersCollectionViewHeightConstraint.constant = membersCollectionView.contentSize.height
		
		return self
	}
}

extension AboutCell: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int {
		if collectionView == membersCollectionView {
			return members.count
		}
		return social.count
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == membersCollectionView {
			return collectionView.dequeueReusableCell(
				withReuseIdentifier: R.reuseIdentifier.memberCell, for: indexPath)!
				.setup(with: members[indexPath.item])
		}
		return collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.socialCell,
													  for: indexPath)!
			.setup(with: social[indexPath.item])
	}
}

extension AboutCell: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView == membersCollectionView {
			memberBlock?(members[indexPath.item])
		}
		else {
			block?(social[indexPath.item])
		}
	}
}
