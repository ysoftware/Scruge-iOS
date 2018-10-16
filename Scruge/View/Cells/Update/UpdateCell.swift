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
	
	@discardableResult
	func setup(with vm: UpdateVM, hideDate:Bool = true) -> Self {
		titleLabel.text = vm.title
		descriptionLabel.text = vm.descsription
		dateLabel.text = vm.date
		dateLabel.isHidden = hideDate

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
}
