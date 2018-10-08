//
//  CoreGraphicsTools.swift
//  Scruge
//
//  Created by ysoftware on 08/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import CoreGraphics

extension CGSize {

	func center(in rect:CGRect) -> CGRect {
		return CGRect(x: rect.origin.x + (rect.width - width) / 2,
					  y: rect.origin.y + (rect.height - height) / 2,
					  width: width,
					  height: height)
	}

	var rect:CGRect {
		return CGRect(origin: .zero, size: self)
	}
}

extension CGRect {

	func fit(in rect:CGRect) -> CGRect {
		let targetSize = rect.size
		if targetSize == .zero {
			return .zero
		}
		let widthRatio = targetSize.width / size.width
		let heightRatio = targetSize.height / size.height
		let scalingFactor = min(widthRatio, heightRatio)
		let newSize = CGSize(width: size.width * scalingFactor, height: size.height * scalingFactor)
		let origin = CGPoint(x: (targetSize.width - newSize.width) / 2,
							 y: (targetSize.height - newSize.height) / 2)
		return CGRect(origin: origin, size: newSize)
	}

	func fill(rect:CGRect) -> CGRect {
		let targetSize = rect.size
		if targetSize == .zero {
			return .zero
		}
		let widthRatio = targetSize.width / size.width
		let heightRatio = targetSize.height / size.height
		let scalingFactor = max(widthRatio, heightRatio)
		let newSize = CGSize(width: size.width * scalingFactor, height: size.height * scalingFactor)
		let origin = CGPoint(x: (targetSize.width - newSize.width) / 2,
							 y: (targetSize.height - newSize.height) / 2)
		return CGRect(origin: origin, size: newSize)
	}
}

enum ScalingMode {

	case aspectFill

	case aspectFit

	func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
		let aspectWidth  = size.width/otherSize.width
		let aspectHeight = size.height/otherSize.height

		switch self {
		case .aspectFill: return max(aspectWidth, aspectHeight)
		case .aspectFit: return min(aspectWidth, aspectHeight)
		}
	}
}
