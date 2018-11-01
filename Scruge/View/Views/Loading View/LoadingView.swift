//
//  LoadingView.swift
//  Scruge
//
//  Created by ysoftware on 05/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class LoadingView: UIView {

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
		Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		set(state: .loading)
	}

	// MARK: - Outlets

	@IBOutlet var contentView: UIView!
	@IBOutlet var loadingView: UIView!
	@IBOutlet var errorView: ErrorView!

	// MARK: - Properties

	weak var errorViewDelegate:ErrorViewDelegate? {
		didSet {
			errorView.delegate = errorViewDelegate
		}
	}

	// MARK: - Methods

	func set(state:ViewState) {
		switch state {
		case .loading:
			isHidden = false
			loadingView.isHidden = false
			errorView.isHidden = true
		case .error(let message):
			isHidden = false
			loadingView.isHidden = true
			errorView.isHidden = false
			errorView.set(message: message)
		case .ready:
			isHidden = true
		}
	}
}
