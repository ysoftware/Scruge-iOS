//
//  RegisterVC.swift
//  Scruge
//
//  Created by ysoftware on 27/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class RegisterViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var registerButton: Button!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var confirmPasswordField: UITextField!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationController?.navigationBar.isHidden = true
		registerButton.addClick(self, action: #selector(signUp))
	}

	// MARK: - Actions

	@objc func cancel(_ sender:Any) {
		view.endEditing(true)
		dismiss(animated: true)
		authCompletionBlock?(false)
	}

	@IBAction func close(_ sender: Any) {
		self.navigationController?.dismiss(animated: true)
	}

	@IBAction func login(_ sender: Any) {
		Service.presenter.replaceWithLoginViewController(viewController: self,
														 completion: authCompletionBlock)
	}

	@objc func signUp(_ sender: Any) {
		guard !isWorking, validate() else { return }

		let email = self.email
		let password = self.password

		isWorking = true
		Service.api.signUp(email: email, password: password) { result in
			self.isWorking = false

			switch result {
			case .success(let response):
				if let error = ErrorHandler.error(from: response.result) {
					return self.alert(error)
				}
				self.finishLogin(email: email, password: password)
			case .failure(let error):
				self.alert(error)
			}
		}
	}

	@IBAction func openPrivacyPolicy(_ sender: Any) {
		#warning("open privacy url")
	}

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	private func finishLogin(email:String, password:String) {
		isWorking = true
		Service.api.logIn(email: email, password: password) { result in
			self.isWorking = false

			switch result {
			case .success(let response):
				Service.tokenManager.save(response.token)
				Service.presenter.presentProfileSetupViewController(in: self,
																	completion: self.authCompletionBlock)
			case .failure(let error):
				self.alert(error)
			}
		}
	}

	// MARK: - Properties

	var authCompletionBlock:((Bool)->Void)!

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

	private var confirmPassword:String {
		return confirmPasswordField.text ?? ""
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

		guard password == confirmPassword else {
			alert("Passwords do not match")
			return false
		}

		guard email.isValidEmail else {
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

extension RegisterViewController: UITextFieldDelegate {

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
