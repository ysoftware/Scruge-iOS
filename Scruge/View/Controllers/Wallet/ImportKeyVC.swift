//
//  ImportKeyVC.swift
//  Scruge
//
//  Created by ysoftware on 18/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ImportKeyViewController: UIViewController {

	@IBOutlet weak var scrollView:UIScrollView!
	@IBOutlet weak var passcodeField:UITextField!
	@IBOutlet weak var keyField:UITextField!
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

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupNavigationBar() {
		title = "Import key"
		makeNavbarNormal(with: "Import key", tint: view.tintColor)
		preferSmallNavbar()
	}

	// MARK: - Actions

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	@IBAction func createAccount(_ sender:Any) {
		Service.presenter.replaceWithCreateAccountViewController(with: self)
	}

	@IBAction func save(_ sender:Any) {
		let key = keyField.text ?? ""
		let passcode = passcodeField.text ?? ""

		guard key.count > 0 else {
			return alert("Enter your private key")
		}

		guard key.count == 51, key.starts(with: "5") else {
			return alert("Incorrect format of private key")
		}

		guard passcode.count > 0 else {
			return alert("Enter your new passcode")
		}

		// if existed
		Service.wallet.deleteWallet()

		Service.wallet.importKey(key, passcode: passcode) { account in
			if account != nil {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
					Service.presenter.replaceWithWalletViewController(with: self)
				}
			}
			else {
				self.alert("Error: Could not import this key")
			}
		}
	}
}

extension ImportKeyViewController {

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
