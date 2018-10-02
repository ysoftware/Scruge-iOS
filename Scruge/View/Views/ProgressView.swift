//
//  ProgressView.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

@IBDesignable
final class ProgressView: RoundedView {

	private let progressView = UIView()

	@IBInspectable var color:UIColor = .red {
		didSet {
			progressView.backgroundColor = color
		}
	}

	@IBInspectable var progress:Double = 0 {
		didSet {
			layoutSubviews()
		}
	}

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
		addSubview(progressView)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		
		let width = bounds.width * CGFloat(progress)
		progressView.frame = CGRect(x: 0, y: 0, width: width, height: bounds.height)
	}
}
