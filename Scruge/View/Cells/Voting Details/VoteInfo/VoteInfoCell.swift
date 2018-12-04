//
//  VoteInfoCell.swift
//  Scruge
//
//  Created by ysoftware on 03/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class VoteInfoCell: UITableViewCell {

	@IBOutlet weak var topWebView: UIWebView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var rightLabel: UILabel?
	@IBOutlet weak var topImage: UIImageView?

	private var didLoadMedia = false
	private var imageUrl:URL?

	// MARK: - Setup

	#warning("refactor to view model")

	@discardableResult
	func setup(with vm:PartialCampaignViewModel, kind:VoteKind) -> Self {
		self.imageUrl = vm.imageUrl

		selectionStyle = .none
		titleLabel!.text = vm.title
		rightLabel?.text = vm.daysLeft

		if kind == .extend {
			descriptionLabel?.text = "Voting whether to extend deadlines of the milestone."
		}
		else {
			descriptionLabel?.text = "Voting to accept milestone results and release next portions of funds to the founders of the campaign or to return remaining funds to backers and close the campaign."
		}

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

extension VoteInfoCell: UIWebViewDelegate {

	func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
		setupImageView()
	}
}
