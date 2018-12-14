//
//  CreateAccountVC.swift
//  Scruge
//
//  Created by ysoftware on 28/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class CreateAccountViewController: UIViewController {

	@IBOutlet weak var scrollView:UIScrollView!
	@IBOutlet weak var passcodeField:UITextField!
	@IBOutlet weak var passcodeConfirmField:UITextField!
	@IBOutlet weak var accountNameField:UITextField!
	@IBOutlet weak var button:Button!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupButton()
		setupKeyboard()
		setupNavigationBar()
	}

	private func setupButton() {
		button.addClick(self, action: #selector(save))
	}

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	@IBAction func importKey(_ sender: Any) {
		Service.presenter.replaceWithImporKeyViewController(with: self)
	}

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupNavigationBar() {
		makeNavbarNormal(with: "Create account")
		preferSmallNavbar()
	}

	@IBAction func save(_ sender:Any) {
		let passcode = passcodeField.text!
		let confirm = passcodeConfirmField.text!
		let name = accountNameField.text!

		guard name.count == 12 else {
			return alert("Account name should be exactly 12 symbols long")
		}

		guard passcode.count > 0 else {
			return alert("Enter your new passcode")
		}

		guard passcode == confirm else {
			return alert("Passwords do not match")
		}

		#warning("refactor to view model")
		Service.wallet.createKey(passcode: passcode) { account in
			guard let publicKey = account?.rawPublicKey else {
				return self.alert(WalletError.unknown)
			}

			// create account
			Service.api.createAccount(withName: name, publicKey: publicKey) { result in
				switch result {
				case .success(let response):
					if response.result == 0 {
						Service.presenter.replaceWithWalletViewController(with: self)
					}
					else {
						self.alert(ErrorHandler.error(from: response.result) ?? BackendError.unknown)
					}
				case .failure(let error):
					self.alert(ErrorHandler.message(for: error))
				}
			}
		}
	}
}

extension CreateAccountViewController {

	@objc func keyboardWillShow(notification:NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		let convertedFrame = view.convert(keyboardFrame, from: nil)
		scrollView.contentInset.bottom = convertedFrame.size.height
		scrollView.scrollIndicatorInsets.bottom = convertedFrame.size.height
	}

	@objc func keyboardWillHide(notification:NSNotification) {
		scrollView.contentInset.bottom = 0
	}
}
