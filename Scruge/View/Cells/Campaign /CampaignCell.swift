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

	@IBOutlet weak var topWebView: UIWebView?
	@IBOutlet weak var descriptionLabel: UILabel?
	@IBOutlet weak var topImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var raisedLabel: UILabel!
	@IBOutlet weak var leftLabel: UILabel!
	@IBOutlet weak var rightLabel: UILabel!
	@IBOutlet weak var progressView: ProgressView!

	private var didLoadMedia = false
	private var imageUrl:URL?

	// MARK: - Setup

	@discardableResult
	func setup(with vm:PartialCampaignViewModel) -> CampaignCell {
		self.imageUrl = vm.imageUrl

		selectionStyle = .none
		progressView.isRelativeRadius = false
		progressView.cornerRadius = 3
		progressView.clipsToBounds = true

		titleLabel.text = vm.title
		descriptionLabel?.text = vm.description
		leftLabel.text = vm.progressString
		raisedLabel.text = vm.raisedString
		rightLabel.text = vm.daysLeft
		progressView.progress = vm.progress

		if let vm = vm as? CampaignVM, let mediaUrl = vm.mediaUrl {
			setupWebView(with: mediaUrl)
		}
		else {
			setupImageView()
		}
		return self
	}

	func setupWebView(with url:URL) {
		guard !didLoadMedia, let topWebView = topWebView else {
			return
		}
		topWebView.isHidden = true
		topImage.isHidden = true
		topWebView.delegate = self
		topWebView.loadRequest(URLRequest(url: url))
		topWebView.isHidden = false
		topWebView.scrollView.isScrollEnabled = false
		topWebView.allowsInlineMediaPlayback = true
		didLoadMedia = true
	}

	private func setupImageView() {
		topWebView?.isHidden = true
		topImage.isHidden = false

		if let url = imageUrl {
			topImage.isHidden = false
			topImage.kf.setImage(with: url)
		}
		else {
			topImage.isHidden = true
		}
	}
}

extension CampaignCell: UIWebViewDelegate {

	func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
		setupImageView()
	}
}
