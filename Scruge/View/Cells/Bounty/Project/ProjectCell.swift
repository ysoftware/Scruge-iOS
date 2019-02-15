//
//  ProjectCell.swift
//  Scruge
//
//  Created by ysoftware on 15/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class ProjectCell: UITableViewCell {

	@IBOutlet weak var logoImage: RoundedImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	@discardableResult
	func setup(with project:ProjectVM) -> Self {
		selectionStyle = .none

		titleLabel.text = project.name
		descriptionLabel.text = project.description
		logoImage.setImage(string: project.imageUrl, hideOnFail: true)
		return self
	}
}
