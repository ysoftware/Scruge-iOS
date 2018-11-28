//
//  SocialCell.swift
//  Scruge
//
//  Created by ysoftware on 11/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class AboutCell: UITableViewCell {

	@IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
	
	@IBOutlet weak var collectionView:UICollectionView!
	@IBOutlet weak var aboutLabel:UILabel!
	
	var social:[Social] = []
	var block:((Social)->Void)?

	@discardableResult
	func tap(_ tap: @escaping (Social)->Void) -> Self {
		self.block = tap
		return self
	}

	@discardableResult
	func setup(with vm:CampaignVM) -> Self {
		social = vm.social
		aboutLabel.text = vm.about

		collectionView.register(UINib(resource: R.nib.socialCell),
								forCellWithReuseIdentifier: R.nib.socialCell.identifier)
		collectionHeightConstraint.constant = social.count > 0 ? 35 : 0
		collectionView.isHidden = social.count == 0
		collectionView.reloadData()
		return self
	}
}

extension AboutCell: UICollectionViewDataSource {

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

extension AboutCell: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		block?(social[indexPath.item])
	}
}
