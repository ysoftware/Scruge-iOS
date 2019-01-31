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

		localize()
		navigationController?.navigationBar.isHidden = true
		loginButton.addClick(self, action: #selector(login))
	}

	// MARK: - Actions

	@IBAction func close(_ sender: Any) {
		self.navigationController?.dismiss(animated: true)
	}

	@objc func cancel(_ sender:Any) {
		view.endEditing(true)
		dismiss(animated: true)
		authCompletionBlock?(false)
	}

	@objc func login(_ sender: Any) {
		guard !isWorking, validate() else { return }

		isWorking = true
		Service.api.logIn(email: email, password: password) { result in
			self.isWorking = false

			switch result {
			case .success(let response):
				Service.tokenManager.save(response.token)
				
				self.view.endEditing(true)
				self.navigationController?.dismiss(animated: true)
				self.authCompletionBlock?(true)
				
			case .failure(let error):
				self.alert(error)
			}
		}
	}

	@IBAction func signUp(_ sender: Any) {
		Service.presenter.replaceWithRegisterViewController(viewController: self,
															completion: authCompletionBlock)
	}

	@IBAction func openPrivacyPolicy(_ sender: Any) {
		Service.presenter.presentPrivacyPolicy(in: self)
	}

	@IBAction func resetPassword(_ sender: Any) {
		askForInput(R.string.localizable.title_reset_password(),
					question: R.string.localizable.label_enter_your_email(),
					placeholder: R.string.localizable.hint_email_address(),
					keyboardType: .emailAddress,
					initialInput: emailField.text,
					isSecure: false,
					actionTitle: R.string.localizable.do_send()) { input in
						guard let login = input else { return }

						guard login.isValidEmail else {
							return self.alert(AuthError.invalidEmail)
						}

						Service.api.resetPassword(login: login) { result in
							switch result {
							case .success(let response):
								if let error = ErrorHandler.error(from: response.result) {
									self.alert(error)
								}
								else {
									self.alert(R.string.localizable.label_reset_password_message())
								}
							case .failure(let error):
								self.alert(error)
							}
						}
		}
	}

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
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

	// MARK: - Methods

	private func validate() -> Bool {

		guard email.isNotBlank else {
			alert(R.string.localizable.error_login_enter_email())
			return false
		}

		guard password.isNotEmpty else {
			alert(R.string.localizable.error_login_enter_password())
			return false
		}

		guard email.isValidEmail else {
			alert(AuthError.invalidEmail)
			return false
		}

		guard password.count > 6 else {
			alert(AuthError.incorrectPasswordLength)
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
