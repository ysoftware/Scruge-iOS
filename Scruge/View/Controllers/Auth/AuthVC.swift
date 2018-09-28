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
			case .success(let response): self.handle(response)
			case .failure(let error): self.showError(error)
			}
		}
	}

	@IBAction func signUp(_ sender: Any) {
		Service.api.signUp(email: email, password: password) { result in
			switch result {
			case .success(let response): self.handle(response, created: true)
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

	func handle(_ response: AuthResponse, created:Bool = false) {
		if response.errorCode != nil {
			return showError(code: response.errorCode!)
		}

		guard response.success, let token = response.token else {
			return showError()
		}

		if created {
			// TO-DO: open profile setup

		}
		else {
			navigationController?.dismiss(animated: true)
		}

		Service.tokenManager.save(token)
	}

	// MARK: - Show error

	func showError(_ error:Error? = nil) {
		guard let error = error else { return }
		switch error {
		case NetworkingError.connectionProblem: alert("Connection problem")
		default: alert("Unexpected error")
		}
	}

	func showError(code:Int) {
		switch code {
		case 1: alert("Email already taken")
		case 2: alert("Incorrect credentials")
		default: showError()
		}
	}
}
