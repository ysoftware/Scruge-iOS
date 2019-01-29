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

	@IBOutlet weak var descriptionStackView: UIStackView!
	@IBOutlet weak var titleStackView: UIStackView!

	@IBOutlet weak var bottomDecorView: UIView!
	@IBOutlet weak var topDecorView: UIView!
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

		activityLabel.isHidden = false
		iconImage.image = vm.icon
		iconBackground.backgroundColor = vm.color
		// TO-DO: image?

		switch vm.type {
		case .update:
			dateLabel.text = vm.updateDate
			updateTitleLabel.text = vm.updateTitle
			updateDescriptionLabel.text = vm.updateDescription
			updateImage.setImage(string: vm.updateImage)
			activityLabel.attributedText = vm.updateActivity
		case .reply:
			updateImage.image = nil
			dateLabel.text = vm.replyDate
			updateTitleLabel.text = vm.replyAuthorName
			updateDescriptionLabel.text = vm.replyText
			activityLabel.isHidden = true
		case .voting:
			updateImage.image = nil
			dateLabel.text = vm.votingDate
			updateTitleLabel.text = vm.votingTitle
			updateDescriptionLabel.text = vm.votingDescription
			activityLabel.isHidden = true
		case .fundingInfo:
			updateImage.image = nil
			dateLabel.text = vm.fundingDate
			updateTitleLabel.text = vm.fundingTitle
			updateDescriptionLabel.text = vm.fundingDescription
			activityLabel.isHidden = true
		case .votingResults:
			updateImage.image = nil
			dateLabel.text = vm.votingResultDate
			updateTitleLabel.text = vm.votingResultTitle
			updateDescriptionLabel.text = vm.votingResultDescription
			activityLabel.isHidden = true
		}

		titleStackView.gestureRecognizers = []
		descriptionStackView.gestureRecognizers = []

		return self
	}

	func showDecor(_ isFirst: Bool, isLast:Bool) -> Self {
		bottomDecorView.isHidden = isLast
		topDecorView.isHidden = isFirst
		return self
	}

	// MARK: - Tap

	private var campaignBlock:((Int)->Void)?
	private var updateBlock:((UpdateVM)->Void)?
	private var replyBlock:((String)->Void)?

	@discardableResult
	func updateTap(block: @escaping (UpdateVM)->Void) -> Self {
		switch vm.type {
		case .update:
			updateBlock = block
			titleStackView.gestureRecognizers = [
				UITapGestureRecognizer(target: self,
									   action: #selector(updateTapped))]
		default: break
		}
		return self
	}

	@discardableResult
	func campaignTap(block: @escaping (Int)->Void) -> Self {
		switch vm.type {
		case .fundingInfo, .update, .voting, .votingResults:
			campaignBlock = block
			descriptionStackView.gestureRecognizers = [
				UITapGestureRecognizer(target: self,
									   action: #selector(campaignTapped))]
		default: break
		}
		return self
	}

	@discardableResult
	func replyTap(block: @escaping (String)->Void) -> Self {
		switch vm.type {
		case .reply:
			replyBlock = block
			descriptionStackView.gestureRecognizers = [
				UITapGestureRecognizer(target: self,
									   action: #selector(replyTapped))]
		default: break
		}
		return self
	}

	@objc func updateTapped() {
		vm.updateVM.flatMap { updateBlock?($0) }
	}

	@objc func campaignTapped() {
		vm.campaignId.flatMap { campaignBlock?($0) }
	}

	@objc func replyTapped() {
		vm.replyId.flatMap { replyBlock?($0) }
	}
}
