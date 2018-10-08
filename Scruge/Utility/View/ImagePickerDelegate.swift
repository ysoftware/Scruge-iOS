//
//  ImagePickerDelegate.swift
//  Scruge
//
//  Created by ysoftware on 08/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	private let block:(UIImage?)->Void

	init(_ block: @escaping (UIImage?)->Void) {
		self.block = block
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		block(nil)
	}

	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let imgage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
		block(imgage?.fixOrientation())
	}
}
