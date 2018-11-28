//
//  CreateAccountVC.swift
//  Scruge
//
//  Created by ysoftware on 28/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class CreateAccountViewController: UIViewController {

	func setupNavigationBar() {
		title = "Create account"

		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = false
		}
	}
}
