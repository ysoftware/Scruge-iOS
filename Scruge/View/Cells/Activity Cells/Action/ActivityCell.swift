//
//  UpdateActivityCell.swift
//  Scruge
//
//  Created by ysoftware on 28/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import appendAttributedString

final class ActivityCell: UITableViewCell {

	@IBOutlet weak var iconImage: UIImageView!
	@IBOutlet weak var iconBackground: RoundedView!
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var activityLabel: UILabel!
	@IBOutlet var updateTitleLabel: UILabel!
	@IBOutlet var updateDescriptionLabel: UILabel!
	@IBOutlet var updateImage: UIImageView!
	
	// MARK: - Setup

	private var vm:ActivityVM!

	@discardableResult
	func setup(with vm: ActivityVM) -> Self {
		self.vm = vm

		selectionStyle = .none
		let font = UIFont.systemFont(ofSize: 14, weight: .semibold)

		iconImage.image = vm.icon
		iconBackground.backgroundColor = vm.color
		// TO-DO: image?

		switch vm.type {
		case .update:
			dateLabel.text = vm.updateDate
			updateTitleLabel.text = vm.updateTitle
			updateDescriptionLabel.text = vm.updateDescription

			activityLabel.isHidden = false
			activityLabel.attributedText = NSMutableAttributedString()
				.append(vm.updateCampaignTitle, color: Service.constants.color.purple, font: font)
				.append(" posted an update", color: Service.constants.color.grayTitle, font: font)
		case .reply:
			dateLabel.text = vm.replyDate
			updateTitleLabel.text = "\(vm.replyAuthorName) replied to your comment"
			activityLabel.isHidden = true
			updateDescriptionLabel.text = vm.replyText

			// TO-DO: other cases
		default: break
		}
		return self
	}

	// MARK: - Tap

	private var campaignBlock:((ActivityVM)->Void)?
	private var updateBlock:((ActivityVM)->Void)?

	@discardableResult
	func updateTap(block: @escaping (ActivityVM)->Void) -> Self {
		updateBlock = block
		updateDescriptionLabel.gestureRecognizers = [
			UITapGestureRecognizer(target: self,
								   action: #selector(updateTapped))]
		return self
	}

	@discardableResult
	func campaignTap(block: @escaping (ActivityVM)->Void) -> Self {
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
