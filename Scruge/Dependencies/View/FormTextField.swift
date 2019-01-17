//
//  FormTextField.swift
//  Scruge
//
//  Created by ysoftware on 17/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

@IBDesignable
final public class FormTextField: UITextField {

	@IBInspectable var inset: CGFloat = 0 {
		didSet {
			leftView = UIView(frame: CGRect(x: 0, y: 0, width: inset, height: 20))
			leftViewMode = .always
		}
	}
}
