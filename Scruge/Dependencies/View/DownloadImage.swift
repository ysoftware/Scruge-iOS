//
//  DownloadImage.swift
//  Scruge
//
//  Created by ysoftware on 31/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {

	func setImage(url:URL?, hideOnFail:Bool = true) {
		if let url = url {
			self.isHidden = false
			self.kf.setImage(with: url) { image, _, _, _ in
				if hideOnFail {
					DispatchQueue.main.async {
						self.isHidden = image == nil
					}
				}
			}
		}
		else {
			if hideOnFail {
				self.isHidden = true
			}
		}
	}

	func setImage(string:String?, hideOnFail:Bool = true) {
		if let string = string {
			let url = URL(string: string)
			setImage(url: url, hideOnFail: true)
		}
		else {
			setImage(url: nil, hideOnFail: true)
		}
	}
}
