//
//  SocialCell.swift
//  Scruge
//
//  Created by ysoftware on 11/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class AboutCell: UITableViewCell {

	@IBOutlet weak var collectionView:UICollectionView!
	@IBOutlet weak var aboutLabel:UILabel!

	var social:[SocialElement] = []

	@discardableResult
	func setup(with vm:CampaignVM) -> Self {
		social = vm.social
		aboutLabel.text = vm.about
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
		let cell = UICollectionViewCell()
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		cell.contentView.addSubview(imageView)
		imageView.image = social[indexPath.item].image
		return cell
	}
}

extension SocialElement {

	var image:UIImage {
		switch type {
		case .twitter: return #imageLiteral(resourceName: "twitter")
		case .facebook: return #imageLiteral(resourceName: "facebook.jpg")
		case .instagram: return #imageLiteral(resourceName: "instagram.jpg")
		case .vk: return #imageLiteral(resourceName: "vk.jpg")
		case .website: return #imageLiteral(resourceName: "website.jpg")
		case .youtube: return #imageLiteral(resourceName: "youtube.jpg")
		}
	}
}
