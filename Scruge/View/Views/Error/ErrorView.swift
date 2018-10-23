//
//  ErrorView.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ErrorView: UIView {

	// MARK: - Init

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	private func setup() {
		Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		showTryAgainButtonIfNeeded()
	}

	// MARK: - Outlets

	@IBOutlet var contentView: UIView!
	@IBOutlet weak var errorLabel:UILabel!
	@IBOutlet weak var tryAgainButton: UIButton!

	// MARK: - Actions

	@IBAction func tryAgain(_ sender: Any) {
		delegate?.didTryAgain()
	}

	// MARK: - Properties

	weak var delegate:ErrorViewDelegate? {
		didSet {
			showTryAgainButtonIfNeeded()
		}
	}

	// MARK: - Methods

	func setButtonTitle(_ title:String) {
		tryAgainButton.setTitle(title, for: .normal)
	}

	private func showTryAgainButtonIfNeeded() {
		tryAgainButton.isHidden = delegate == nil
	}

	func set(message:String) {
		errorLabel.text = message
	}
}

protocol ErrorViewDelegate: class {

	func didTryAgain()
}
