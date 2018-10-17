//
//  ImageTools.swift
//  Scruge
//
//  Created by ysoftware on 08/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

/// Метод-обёртка для использования правильного api для рисования на разных системах.
public func beginDrawing(in size:CGSize,
						 opaque:Bool = false,
						 scale:CGFloat = 0,
						 _ body:(CGContext)->Void) -> UIImage {

	if #available(iOS 10.0, *) {
		let format:UIGraphicsImageRendererFormat = .default()
		format.opaque = opaque
		format.scale = scale
		let renderer = UIGraphicsImageRenderer(bounds: size.rect, format: format)
		return renderer.image { renderContext in
			body(renderContext.cgContext)
		}
	}
	else {
		UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
		body(UIGraphicsGetCurrentContext()!)
		let result = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return result
	}
}

extension UIImage {

	func scaled(to newSize: CGSize) -> UIImage {
		let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
		return beginDrawing(in: newSize, opaque: false, scale: 0) { context in
			guard let cgImage = cgImage else { return }
			context.interpolationQuality = .high
			let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
			context.concatenate(flipVertical)
			context.draw(cgImage, in: newRect)
		}
	}

	func downscaled(to max:CGFloat) -> UIImage {
		let width = size.width * scale
		let height = size.height * scale

		guard width > max || height > max else { return self }

		let newSize:CGSize
		if width > height {
			let aspect = height/width
			newSize = CGSize(width: max, height: max*aspect)
		}
		else {
			let aspect = width/height
			newSize = CGSize(width: max*aspect, height: max)
		}
		return scaled(to: newSize)
	}

	func fixOrientation() -> UIImage {
		if imageOrientation == .up { return self }

		var transform:CGAffineTransform = .identity
		switch imageOrientation {
		case .down, .downMirrored:
			transform = transform.translatedBy(x: size.width, y: size.height).rotated(by: .pi)
		case .left, .leftMirrored:
			transform = transform.translatedBy(x: size.width, y: 0).rotated(by: .pi/2)
		case .right, .rightMirrored:
			transform = transform.translatedBy(x: 0, y: size.height).rotated(by: -.pi/2)
		default: break
		}

		switch imageOrientation {
		case .upMirrored, .downMirrored:
			transform = transform.translatedBy(x: size.width, y: 0).scaledBy(x: -1, y: 1)
		case .leftMirrored, .rightMirrored:
			transform = transform.translatedBy(x: size.height, y: 0).scaledBy(x: -1, y: 1)
		default: break
		}

		let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
							bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
							space: cgImage!.colorSpace!, bitmapInfo: cgImage!.bitmapInfo.rawValue)!
		ctx.concatenate(transform)

		switch imageOrientation {
		case .left, .leftMirrored, .right, .rightMirrored:
			ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height,height: size.width))
		default:
			ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width,height: size.height))
		}
		return UIImage(cgImage: ctx.makeImage()!)
	}
}
