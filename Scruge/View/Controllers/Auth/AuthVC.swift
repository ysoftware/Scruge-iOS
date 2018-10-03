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
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	// MARK: - Actions

	@IBAction func login(_ sender: Any) {
		guard validate() else { return }

		isWorking = true
		Service.api.logIn(email: email, password: password) { result in
			self.isWorking = false

			switch result {
			case .success(let response):

				guard response.result == 0 else {
					return self.showError(code: response.result)
				}

				guard let token = response.token else {
					return self.showError()
				}
				self.navigationController?.dismiss(animated: true)
				Service.tokenManager.save(token)
				
			case .failure(let error): self.showError(error)
			}
		}
	}

	@IBAction func signUp(_ sender: Any) {
		guard validate() else { return }

		isWorking = true
		Service.api.signUp(email: email, password: password) { result in
			self.isWorking = false

			switch result {
			case .success(let response):

				guard response.result == 0 else {
					return self.showError(code: response.result)
				}
				self.login(self)

			case .failure(let error): self.showError(error)
			}
		}
	}

	@IBAction func openPrivacyPolicy(_ sender: Any) {
		// TO-DO: open privacy url
	}

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	// MARK: - Properties

	var isWorking:Bool = false {
		didSet {
			activityIndicator.alpha = isWorking ? 1 : 0
		}
	}

	var email:String {
		return emailField.text ?? ""
	}

	var password:String {
		return passwordField.text ?? ""
	}

	// MARK: - Methods

	func validate() -> Bool {

		if email.isEmpty {
			alert("Enter your email")
			return false
		}

		if password.isEmpty {
			alert("Enter your password")
			return false
		}

		return true
	}

	// MARK: - Show error

	func showError(_ error:Error? = nil) {
		if let error = error {
			switch error {
			case NetworkingError.connectionProblem: alert("Connection problem")
			default: alert("Unexpected error")
			}
		}
		else {
			alert("Unexpected error")
		}
	}

	func showError(code:Int) {
		switch code {
		case 1001: alert("Email already taken")
		case 1002: alert("Incorrect credentials")
		case 1003: alert("User blocked")
		default: showError()
		}
	}
}
