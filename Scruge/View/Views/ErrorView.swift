//
//  ErrorView.swift
//  Scruge
//
//  Created by ysoftware on 02/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ErrorView: UIView {

	@IBOutlet weak var errorLabel:UILabel!

	func set(message:String) {
		errorLabel.text = message
	}
}
