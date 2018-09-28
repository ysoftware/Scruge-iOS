//
//  ViewController.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class AuthViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!

	// MARK: - Actions

	@IBAction func login(_ sender: Any) {
		Service.api.logIn(email: email, password: password) { result in
			switch result {
			case .success(let response):
				guard response.success, let token = response.token else {
					return // self.showError()
				}
				Service.tokenManager.save(token)
				self.dismiss(animated: true)

			case .failure(let error):
				self.showError(error)
			}
		}
	}

	@IBAction func signUp(_ sender: Any) {
		Service.api.signUp(email: email, password: password) { result in
			switch result {
			case .success(let response):
				guard response.success, let token = response.token else {
					return // self.showError()
				}
				Service.tokenManager.save(token)
				// TO-DO: open profile setup
			case .failure(let error):
				self.showError(error)
			}
		}
	}

	@IBAction func openPrivacyPolicy(_ sender: Any) {
		// TO-DO: open privacy url
	}

	// MARK: - Properties

	var email:String {
		return emailField.text ?? ""
	}

	var password:String {
		return passwordField.text ?? ""
	}

	// MARK: - Methods

	override func viewDidLoad() {
		super.viewDidLoad()

	}

	func showError(_ error:Error) {

	}
}
