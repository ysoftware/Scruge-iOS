//
//  RoundedView.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

private let DEFAULT_RADIUS:CGFloat = 5
private let DEFAULT_RELATIVE = false

@IBDesignable
public class RoundedView: UIView {

	@IBInspectable
	public var isRelativeRadius:Bool = DEFAULT_RELATIVE { didSet { setNeedsLayout() } }

	@IBInspectable
	public var cornerRadius:CGFloat = DEFAULT_RADIUS  { didSet { setNeedsLayout() } }

	@IBInspectable
	public var borderWidth:CGFloat = 0  { didSet { setNeedsLayout() } }

	@IBInspectable
	public var borderColor:UIColor = .clear  { didSet { setNeedsLayout() } }

	override public func layoutSubviews() {
		super.layoutSubviews()

		clipsToBounds = true
		layer.masksToBounds = true
		layer.cornerRadius = isRelativeRadius ? frame.height * cornerRadius : cornerRadius

		layer.borderColor = borderColor.cgColor
		layer.borderWidth = borderWidth
	}
}

@IBDesignable
public final class RoundedImageView: UIImageView {

	@IBInspectable
	public var isRelativeRadius:Bool = DEFAULT_RELATIVE { didSet { setNeedsLayout() } }

	@IBInspectable
	public var cornerRadius:CGFloat = DEFAULT_RADIUS  { didSet { setNeedsLayout() } }

	@IBInspectable
	public var borderWidth:CGFloat = 0  { didSet { setNeedsLayout() } }

	@IBInspectable
	public var borderColor:UIColor = .clear  { didSet { setNeedsLayout() } }

	override public func layoutSubviews() {
		super.layoutSubviews()

		clipsToBounds = true
		layer.masksToBounds = true
		layer.cornerRadius = isRelativeRadius ? frame.height * cornerRadius : cornerRadius
		layer.borderColor = borderColor.cgColor
		layer.borderWidth = borderWidth
	}
}
