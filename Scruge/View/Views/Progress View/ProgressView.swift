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
	
	@IBOutlet weak var currentLabelRight: UILabel!
	@IBOutlet weak var currentLabel:UILabel!

	enum Mode { case funding, progress(tintColor:UIColor, backColor:UIColor, showLabels:Bool) }
	
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
		localize()
	}

	// MARK: - Properties

	@IBInspectable var value:Double = 0 { didSet { updateLayout() }}
	@IBInspectable var total:Double = 10 { didSet { updateLayout() }}
	@IBInspectable var firstGoal:Double = 8 { didSet { updateLayout() }}
	@IBInspectable var prefix = "$" { didSet { updateLayout() }}
	@IBInspectable var suffix = "" { didSet { updateLayout() }}
	var mode = Mode.funding { didSet { updateLayout() }}

	private var reachedGoal:Bool { return value >= firstGoal }

	func updateLayout() {
		let progress = max(0, min(1, value / firstGoal))
		trailingConstraint.constant = bounds.width * CGFloat(progress)
		indicatorView.isHidden = reachedGoal

		currentLabel.text = "\(prefix)\(value.formatDecimal(separateWith: " "))\(suffix)"
		currentLabelRight.text = "\(prefix)\(value.formatDecimal(separateWith: " "))\(suffix)"

		switch mode {
		case .funding:
			let showLeftLabel = progress > 0.5
			if reachedGoal {
				totalLabel.textColor = Service.constants.color.greenLight
				barView.backgroundColor = Service.constants.color.greenLight
			}
			else {
				totalLabel.textColor = Service.constants.color.gray
				barView.backgroundColor = Service.constants.color.purpleLight
			}

			totalLabel.text = "\(prefix)\(total.formatDecimal(separateWith: " "))\(suffix)"
			currentLabel.isHidden = !showLeftLabel
			currentLabelRight.isHidden = showLeftLabel

		case .progress(let tintColor, let backColor, let showLabels):
			totalLabel.isHidden = true
			indicatorView.backgroundColor = backColor
			barView.backgroundColor = tintColor
			currentLabel.isHidden = !showLabels
			currentLabelRight.isHidden = !showLabels
			break
		}

		setNeedsUpdateConstraints()
		setNeedsLayout()
	}
}
