//
//  StatusBar.swift
//  Scruge
//
//  Created by ysoftware on 27/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

extension UINavigationController {

	open override var preferredStatusBarStyle: UIStatusBarStyle {
		return topViewController?.preferredStatusBarStyle ?? .default
	}
}
