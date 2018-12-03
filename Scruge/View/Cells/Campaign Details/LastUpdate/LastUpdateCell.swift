//
//  UpdateCell.swift
//  Scruge
//
//  Created by ysoftware on 01/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import Kingfisher

final class LastUpdateCell: UITableViewCell {

	@IBOutlet weak var updateStackView: UIStackView!
	@IBOutlet weak var updateImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var sectionTitleLabel: UILabel!
	
	// MARK: - Setup

	@discardableResult
	func setup(with vm: UpdateVM) -> Self {
		titleLabel.text = vm.title
		descriptionLabel.text = vm.descsription
		sectionTitleLabel.text = "Last update: \(vm.date)"

		updateImage.setImage(string: vm.imageUrl)
		return self
	}

	// MARK: - Tap

	private var allUpdatesBlock:(()->Void)?
	private var updateBlock:(()->Void)?

	@discardableResult
	func updateTap(block: @escaping ()->Void) -> Self {
		updateStackView.gestureRecognizers = [UITapGestureRecognizer(target: self,
																	 action: #selector(updateTapped))]
		updateBlock = block
		return self
	}

	@discardableResult
	func allUpdatesTap(block: @escaping ()->Void) -> Self {
		allUpdatesBlock = block
		return self
	}

	@objc func updateTapped() {
		updateBlock?()
	}

	@IBAction func allUpdatesTapped() {
		allUpdatesBlock?()
	}
}