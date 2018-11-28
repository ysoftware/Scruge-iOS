//
//  ViewController.swift
//  Scruge
//
//  Created by ysoftware on 24.09.2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var loginButton: Button!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationController?.navigationBar.isHidden = true
		loginButton.addClick(self, action: #selector(login))
	}

	// MARK: - Actions

	@objc func cancel(_ sender:Any) {
		view.endEditing(true)
		dismiss(animated: true)
		authCompletionBlock?(false)
	}

	@objc func login(_ sender: Any) {
		guard validate() else { return }

		isWorking = true
		Service.api.logIn(email: email, password: password) { result in
			self.isWorking = false

			switch result {
			case .success(let response):
				Service.tokenManager.save(response.token)

				if self.didSignUp {
					Service.presenter.presentProfileSetupViewController(in: self,
																completion: self.authCompletionBlock)
				}
				else {
					self.view.endEditing(true)
					self.navigationController?.dismiss(animated: true)
					self.authCompletionBlock?(true)
				}
				
			case .failure(let error):
				self.alert(error)
			}
		}
	}

	@IBAction func signUp(_ sender: Any) {
		Service.presenter.replaceWithRegisterViewController(in: self,
															completion: authCompletionBlock)
	}

	@IBAction func openPrivacyPolicy(_ sender: Any) {
		#warning("open privacy url")
	}

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	// MARK: - Properties

	var authCompletionBlock:((Bool)->Void)!

	private var didSignUp = false

	private var isWorking:Bool = false {
		didSet {
			activityIndicator.alpha = isWorking ? 1 : 0
		}
	}

	private var email:String {
		return emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
	}

	private var password:String {
		return passwordField.text ?? ""
	}

	// MARK: - Methods

	private func validate() -> Bool {

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

extension LoginViewController: UITextFieldDelegate {

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