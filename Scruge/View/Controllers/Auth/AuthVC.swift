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

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Continue without login",
															style: .plain,
															target: self,
															action: #selector(cancel))
	}

	// MARK: - Actions

	@objc func cancel(_ sender:Any) {
		view.endEditing(true)
		dismiss(animated: true)
	}

	@IBAction func login(_ sender: Any) {
		guard validate() else { return }

		isWorking = true
		Service.api.logIn(email: email, password: password) { result in
			self.isWorking = false

			switch result {
			case .success(let response):

				if let error = ErrorHandler.error(from: response.result) {
					return self.alert(ErrorHandler.message(for: error))
				}

				guard let token = response.token else {
					return self.alert(ErrorHandler.message(for: NetworkingError.unknown))
				}

				Service.tokenManager.save(token)

				if self.didSignUp {
					Presenter.presentProfileEditViewController(in: self)
				}
				else {
					self.navigationController?.dismiss(animated: true)
				}
				
			case .failure(let error):
				self.alert(ErrorHandler.message(for: error))
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

				if let error = ErrorHandler.error(from: response.result) {
					return self.alert(ErrorHandler.message(for: error))
				}

				self.didSignUp = true
				self.login(self)

			case .failure(let error):
				self.alert(ErrorHandler.message(for: error))
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

	var didSignUp = false

	var isWorking:Bool = false {
		didSet {
			activityIndicator.alpha = isWorking ? 1 : 0
		}
	}

	var email:String {
		return emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
	}

	var password:String {
		return passwordField.text ?? ""
	}

	// MARK: - Methods

	func validate() -> Bool {

		guard email.count > 0 else {
			alert("Enter your email")
			return false
		}

		guard password.count > 0 else {
			alert("Enter your password")
			return false
		}

		guard email.isValidEmail() else {
			alert("Email is not valid")
			return false
		}

		guard password.count > 6 else {
			alert("Password is too short")
			return false
		}

		return true
	}
}

extension AuthViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField,
				shouldChangeCharactersIn range: NSRange,
				replacementString string: String) -> Bool {

		guard let text = textField.text else { return true }
		let newLength = text.count + string.count - range.length

		if textField == emailField {
			return newLength <= 254
		}
		return true
	}
}
