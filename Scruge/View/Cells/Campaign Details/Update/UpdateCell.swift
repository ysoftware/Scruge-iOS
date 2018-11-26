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

	@IBOutlet weak var updateStackView: UIStackView!
	@IBOutlet weak var updateImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var sectionTitleLabel: UILabel!
	
	// MARK: - Setups

	@discardableResult
	func setup(with vm: UpdateVM) -> Self {
		titleLabel.text = vm.title
		descriptionLabel.text = vm.descsription
		sectionTitleLabel.text = "Last update: \(vm.date)"

		updateImage.setImage(string: vm.imageUrl)
		return self
	}

	// MARK: - Tap

	private var campaignBlock:(()->Void)?
	private var updateBlock:(()->Void)?

	@discardableResult
	func setupTap(update: @escaping ()->Void) -> Self {
		updateStackView.gestureRecognizers = [UITapGestureRecognizer(target: self,
																	 action: #selector(updateTapped))]
		updateBlock = update
		return self
	}

	@objc func updateTapped() {
		updateBlock?()
	}
}
