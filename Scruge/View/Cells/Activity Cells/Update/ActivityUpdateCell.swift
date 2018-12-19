//
//  UpdateActivityCell.swift
//  Scruge
//
//  Created by ysoftware on 28/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import appendAttributedString

final class ActivityUpdateCell: UITableViewCell {

	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var activityLabel: UILabel!
	@IBOutlet var updateTitleLabel: UILabel!
	@IBOutlet var updateDescriptionLabel: UILabel!
	@IBOutlet var updateImage: UIImageView!
	
	// MARK: - Setup

	private var vm:UpdateVM!

	@discardableResult
	func setup(with vm: UpdateVM) -> Self {
		self.vm = vm

		dateLabel.text = vm.date
		updateTitleLabel.text = vm.title
		updateDescriptionLabel.text = vm.descsription
		updateImage.setImage(string: vm.imageUrl)
		selectionStyle = .none

		let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
		activityLabel.attributedText = NSMutableAttributedString()
			.append(vm.campaignTitle, color: Service.constants.color.purple, font: font)
			.append(" posted an update", color: Service.constants.color.grayTitle, font: font)
		return self
	}

	// MARK: - Tap

	private var campaignBlock:((UpdateVM)->Void)?
	private var updateBlock:((UpdateVM)->Void)?

	@discardableResult
	func updateTap(block: @escaping (UpdateVM)->Void) -> Self {
		updateBlock = block
		updateDescriptionLabel.gestureRecognizers = [
			UITapGestureRecognizer(target: self,
								   action: #selector(updateTapped))]
		return self
	}

	@discardableResult
	func campaignTap(block: @escaping (UpdateVM)->Void) -> Self {
		campaignBlock = block
		activityLabel.gestureRecognizers = [
			UITapGestureRecognizer(target: self,
								   action: #selector(campaignTapped))]

		return self
	}

	@objc func updateTapped() {
		updateBlock?(vm)
	}

	@IBAction func campaignTapped() {
		campaignBlock?(vm)
	}
}
