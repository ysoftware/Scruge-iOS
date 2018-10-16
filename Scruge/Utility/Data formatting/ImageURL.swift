//
//  ImageURL.swift
//  Scruge
//
//  Created by ysoftware on 16/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import Foundation

extension URL {

	var isValidImageResource: Bool {
		return path.contains(".jpg") || path.contains(".png")
	}
}
