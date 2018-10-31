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
	@IBOutlet weak var dateLabel: UILabel!

	// campaign
	@IBOutlet weak var campaignStackView: UIStackView!
	@IBOutlet weak var campaignTitleLabel: UILabel?
	@IBOutlet weak var campaignImageView: UIImageView!
	
	// MARK: - Setups

	@discardableResult
	func setup(with vm: UpdateVM) -> Self {
		titleLabel.text = vm.title
		descriptionLabel.text = vm.descsription
		dateLabel.text = vm.date

		campaignTitleLabel?.isHidden = true
		campaignTitleLabel?.text = vm.campaignTitle
		campaignImageView.setImage(string: vm.campaignImageUrl)

		updateImage.setImage(string: vm.imageUrl)
		return self
	}

	@discardableResult
	func showDate(_ show:Bool) -> Self {
		dateLabel.isHidden = !show
		return self
	}

	@discardableResult
	func showCampaign(_ show:Bool) -> Self {
		campaignTitleLabel?.isHidden = !show
		return self
	}

	// MARK: - Tap

	private var campaignBlock:(()->Void)?
	private var updateBlock:(()->Void)?

	@discardableResult
	func setupTap(campaign: @escaping ()->Void,
				  update: @escaping ()->Void) -> Self {
		updateStackView.gestureRecognizers = [UITapGestureRecognizer(target: self,
																	 action: #selector(updateTapped))]
		campaignStackView.gestureRecognizers = [UITapGestureRecognizer(target: self,
																	 action: #selector(campaignTapped))]
		campaignBlock = campaign
		updateBlock = update
		return self
	}

	@objc func campaignTapped() {
		campaignBlock?()
	}

	@objc func updateTapped() {
		updateBlock?()
	}
}
