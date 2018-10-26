//
//  UpdateCell.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import Kingfisher

final class UpdateCell: UITableViewCell {
	
	@IBOutlet weak var updateImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!

	// campaign
	@IBOutlet weak var campaignTitleLabel: UILabel!
	@IBOutlet weak var campaignImageLabel: UIImageView!
	
	@discardableResult
	func setup(with vm: UpdateVM) -> Self {
		titleLabel.text = vm.title
		descriptionLabel.text = vm.descsription
		dateLabel.text = vm.date
		campaignTitleLabel?.text = vm.campaignTitle

		if let string = vm.imageUrl, let url = URL(string: string), url.isValidImageResource {
			updateImage.isHidden = false
			updateImage.kf.setImage(with: url) { image, _, _, _ in
				DispatchQueue.main.async {
					self.updateImage.isHidden = image == nil
				}
			}
		}
		else {
			updateImage.isHidden = true
		}
		return self
	}

	@discardableResult
	func showDate(_ show:Bool) -> Self {
		dateLabel.isHidden = !show
		return self
	}

	@discardableResult
	func showCampaign(_ show:Bool) -> Self {
		campaignTitleLabel.isHidden = !show
		return self
	}
}
