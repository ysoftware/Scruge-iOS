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

		localize()
		setupButton()
		setupKeyboard()
		setupNavigationBar()
	}

	private func setupButton() {
		button.addClick(self, action: #selector(save))
	}

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
											   name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
											   name:UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupNavigationBar() {
		title = R.string.localizable.title_import_private_key()
		makeNavbarNormal(with: R.string.localizable.title_import_private_key())
		preferSmallNavbar()
		navigationController?.navigationBar.isHidden = false
	}

	// MARK: - Actions

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	@IBAction func createAccount(_ sender:Any) {
		guard Service.tokenManager.hasToken else {
			return alert(R.string.localizable.alert_sign_in_first())
		}
		Service.presenter.replaceWithCreateAccountViewController(viewController: self)
	}

	@IBAction func save(_ sender:Any) {
		let key = keyField.text ?? ""
		let passcode = passcodeField.text ?? ""

		guard key.isNotBlank else {
			return alert(R.string.localizable.error_enter_private_key())
		}

		guard key.count == 51, key.starts(with: "5") else {
			return alert(R.string.localizable.error_incorrect_key_format())
		}

		guard passcode.isNotEmpty else {
			return alert(R.string.localizable.error_enter_new_password())
		}

		// if existed
		Service.wallet.deleteWallet()

		Service.wallet.importKey(key, passcode: passcode) { account in
			if account != nil {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
					Service.presenter.replaceWithWalletViewController(viewController: self)
				}
			}
			else {
				self.alert(R.string.localizable.error_couldnt_import_private_key())
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
