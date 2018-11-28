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

	override func viewDidLoad() {
		super.viewDidLoad()

		button.addClick(self, action: #selector(save))
		setupKeyboard()
		setupNavigationBar()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		scrollView.invalidateIntrinsicContentSize()
	}

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupNavigationBar() {
		title = "Import key"
		navigationController?.navigationBar.preferSmall()
	}

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	@IBAction func createAccount(_ sender:Any) {
		Service.presenter.replaceWithCreateAccountViewController(with: self)
	}

	@IBAction func save(_ sender:Any) {
		let accountName = keyField.text ?? ""
		let passcode = passcodeField.text ?? ""

		// if existed
		Service.wallet.deleteWallet()

		Service.wallet.importKey(accountName, passcode: passcode) { account in
			if account != nil {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
					self.navigationController?.popViewController(animated: true)
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
