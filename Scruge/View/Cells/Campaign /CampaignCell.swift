//
//  CampaignCell.swift
//  Scruge
//
//  Created by ysoftware on 28/09/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import Kingfisher

final class CampaignCell: UITableViewCell {

	// MARK: - Outlets

	@IBOutlet weak var topWebView: UIWebView!
	@IBOutlet weak var topImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var raisedLabel: UILabel!
	@IBOutlet weak var leftLabel: UILabel!
	@IBOutlet weak var rightLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var progressView: ProgressView!

	// MARK: - Setup

	@discardableResult
	func setup(with vm:PartialCampaignViewModel) -> CampaignCell {

		selectionStyle = .none
		progressView.isRelativeRadius = false
		progressView.cornerRadius = 3
		clipsToBounds = true

		titleLabel.text = vm.title
		descriptionLabel.text = vm.description
		leftLabel.text = vm.progressString
		raisedLabel.text = vm.raisedString
		rightLabel.text = vm.daysLeft
		progressView.progress = vm.progress

		if let vm = vm as? PartialCampaignVM {
			topWebView.isHidden = true

			if let url = vm.imageUrl {
				topImage.isHidden = false
				topImage.kf.setImage(with: url)
			}
			else {
				topImage.isHidden = true
			}
		}
		else if let vm = vm as? CampaignVM {
			topImage.isHidden = true
			setupWebView(with: vm.mediaUrl)
		}
		return self
	}

	func setupWebView(with html:String) {
		guard let url = URL(string: html) else {
			return
		}
		topWebView.loadRequest(URLRequest(url: url))
		topWebView.isHidden = false
		topWebView.scrollView.isScrollEnabled = false
		topWebView.allowsInlineMediaPlayback = true
	}
}
