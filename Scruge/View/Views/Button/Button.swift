//
//  Button.swift
//  Scruge
//
//  Created by ysoftware on 26/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

@IBDesignable 
final class Button: UIView {

	@IBOutlet var contentView: UIView!
	@IBOutlet weak var button: UIButton!
	@IBOutlet weak var backgroundView: RoundedView!

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
		Bundle.main.loadNibNamed("Button", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		contentView.backgroundColor = .clear
		self.backgroundColor = .clear
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		let shadowPath = UIBezierPath(rect: backgroundView.bounds)
		backgroundView.layer.masksToBounds = false
		backgroundView.layer.shadowColor = UIColor.black.cgColor
		backgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
		backgroundView.layer.shadowOpacity = 0.15
		backgroundView.layer.shadowRadius = 5
		backgroundView.layer.shadowPath = shadowPath.cgPath
	}

	@IBInspectable
	public var text:String = "" {
		didSet {
			UIView.performWithoutAnimation {
				self.button.setTitle(self.text, for: .normal)
				self.button.layoutIfNeeded()
			}
		}
	}

	public var color:UIColor = .black {
		didSet {
			backgroundView.backgroundColor = color
		}
	}

	public func addClick(_ target:Any?, action: Selector) {
		button.addTarget(target, action: action, for: .touchUpInside)
	}
}
