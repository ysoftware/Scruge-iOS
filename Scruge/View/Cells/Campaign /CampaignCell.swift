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
	@IBOutlet weak var topImage: UIImageView?
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var leftLabel: UILabel?
	@IBOutlet weak var rightLabel: UILabel?
	@IBOutlet weak var progressView: ProgressView!

	private var didLoadMedia = false
	private var imageUrl:URL?

	// MARK: - Setup

	@discardableResult
	func setup(with vm:PartialCampaignViewModel) -> CampaignCell {
		self.imageUrl = vm.imageUrl

		selectionStyle = .none

		titleLabel!.text = vm.title
		descriptionLabel?.text = vm.description
		rightLabel?.text = vm.daysLeft.uppercased()

		progressView.value = vm.raised
		progressView.total = Double(vm.hardCap)
		progressView.firstGoal = Double(vm.softCap)

		if let vm = vm as? CampaignVM, let videoUrl = vm.videoUrl {
			setupWebView(with: videoUrl)
		}
		else {
			setupImageView()
		}
		return self
	}

	private func setupWebView(with url:URL) {
		guard !didLoadMedia, let topWebView = topWebView else {
			return
		}
		topWebView.isHidden = true
		topImage?.isHidden = true
		topWebView.delegate = self
		topWebView.isHidden = false
		topWebView.scrollView.isScrollEnabled = false
		topWebView.allowsInlineMediaPlayback = false
		topWebView.mediaPlaybackRequiresUserAction = true

		if #available(iOS 11.0, *) {
			topWebView.scrollView.contentInsetAdjustmentBehavior = .never
		}
		topWebView.loadRequest(URLRequest(url: url))
		didLoadMedia = true
	}

	private func setupImageView() {
		topWebView?.isHidden = true
		topImage?.isHidden = false
		topImage?.setImage(url: imageUrl, hideOnFail: false)
	}
}

extension CampaignCell: UIWebViewDelegate {

	func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
		setupImageView()
	}
}
