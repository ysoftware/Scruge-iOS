//
//  SocialCell.swift
//  Scruge
//
//  Created by ysoftware on 11/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class SocialCell: UICollectionViewCell {

	@IBOutlet weak var imageView:UIImageView!

	@discardableResult
	func setup(with element:Social) -> Self {
		imageView.image = element.image
		return self
	}
}

extension Social {

	var image:UIImage {
		switch name {
		case .twitter: return #imageLiteral(resourceName: "twitter")
		case .facebook: return #imageLiteral(resourceName: "facebook.jpg")
		case .instagram: return #imageLiteral(resourceName: "instagram.jpg")
		case .vk: return #imageLiteral(resourceName: "vk.jpg")
		case .website: return #imageLiteral(resourceName: "website.jpg")
		case .youtube: return #imageLiteral(resourceName: "youtube.jpg")
		}
	}
}