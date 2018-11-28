//
//  ProgressView.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

@IBDesignable
final class ProgressView: UIView {

	@IBOutlet var contentView: UIView!
	@IBOutlet weak var trailingConstraint: NSLayoutConstraint!
	@IBOutlet weak var barView:UIView!
	@IBOutlet weak var indicatorView:UIView!
	@IBOutlet weak var totalLabel:UILabel!
	@IBOutlet weak var currentLabel:UILabel!

	// MARK: - Setup

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	private func setup() {
		Bundle.main.loadNibNamed("ProgressView", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		contentView.backgroundColor = .clear
		self.backgroundColor = .clear
	}

	// MARK: - Properties

	@IBInspectable var value:Double = 0 {
		didSet {
			updateLayout()
		}
	}

	@IBInspectable var total:Double = 10 {
		didSet {
			updateLayout()
		}
	}

	@IBInspectable var firstGoal:Double = 8 {
		didSet {
			updateLayout()
		}
	}

	@IBInspectable var prefix = "$" {
		didSet {
			updateLayout()
		}
	}

	@IBInspectable var suffix = "" {
		didSet {
			updateLayout()
		}
	}

	func updateLayout() {
		let progress = max(0, min(1, value / total))
		trailingConstraint.constant = bounds.width * CGFloat(progress)
		totalLabel.text = "\(prefix)\(total.format(as: .decimal, separateWith: " "))\(suffix)"
		currentLabel.text = "\(prefix)\(value.format(as: .decimal, separateWith: " "))\(suffix)"

		if value >= firstGoal {
			indicatorView.backgroundColor = Service.constants.color.green
			barView.backgroundColor = Service.constants.color.greenLight
		}
		else {
			indicatorView.backgroundColor = Service.constants.color.purple
			barView.backgroundColor = Service.constants.color.purpleLight
		}
		updateConstraintsIfNeeded()
		layoutIfNeeded()
		totalLabel.isHidden = currentLabel.frame.intersects(totalLabel.frame)
	}
}