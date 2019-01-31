//
//  CreateAccountVC.swift
//  Scruge
//
//  Created by ysoftware on 28/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class CreateAccountViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var confirmView: UIStackView!
	@IBOutlet weak var scrollView:UIScrollView!
	@IBOutlet weak var passcodeField:UITextField!
	@IBOutlet weak var passcodeConfirmField:UITextField!
	@IBOutlet weak var accountNameField:UITextField!
	@IBOutlet weak var button:Button!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var keyLabel: UILabel!
	@IBOutlet weak var shuffleView: UIStackView!

	// MARK: - Properties

	var publicKey:String!
	private var privateKey:PrivateKey? // nil if publicKey was imported earlier

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupKey()
		setupButton()
		setupKeyboard()
		setupNavigationBar()
		setupViews()
	}

	private func setupViews() {
		let generate =  R.string.localizable.label_create_account_generate_text()
		let imported = R.string.localizable.label_create_account_use_imported_text()

		descriptionLabel.text = Service.wallet.hasAccount ? imported : generate
		confirmView.isHidden = Service.wallet.hasAccount
	}

	private func setupKey() {
		if let account = Service.wallet.getWallet() {
			shuffleView.isHidden = true
			publicKey = account.publicKey
			showKey()
		}
		else {
			newKeypair()
		}
	}

	private func setupButton() {
		button.addClick(self, action: #selector(save))
	}

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	@IBAction func importKey(_ sender: Any) {
		if Service.wallet.hasAccount {
			let t = R.string.localizable.title_sure_to_delete_wallet()
			let q = R.string.localizable.label_sure_to_delete_wallet()
			self.ask(title: t, question: q) { response in
				if response {
					Service.wallet.deleteWallet()
					Service.presenter.replaceWithWalletStartViewController(viewController: self)
				}
			}
		}
		else {
			Service.presenter.replaceWithImporKeyViewController(viewController: self)
		}
	}

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
											   name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
											   name:UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupNavigationBar() {
		makeNavbarNormal(with: R.string.localizable.title_create_eos_account())
		preferSmallNavbar()
		navigationController?.navigationBar.isHidden = false
	}

	@IBAction func newKeypair(_ sender: Any) {
		newKeypair()
	}

	@IBAction func save(_ sender:Any) {
		guard Service.tokenManager.hasToken else {
			return alert(R.string.localizable.alert_sign_in_first())
		}

		let passcode = passcodeField.text!
		let confirm = passcodeConfirmField.text!
		let name = accountNameField.text!

		guard let eosName = name.eosName else {
			return alert(EOSError.incorrectName)
		}

		guard name.count == 12 else {
			return alert(R.string.localizable.error_eos_account_length())
		}

		if let privateKey = privateKey {

			guard passcode.count > 0 else {
				return alert(R.string.localizable.error_enter_new_password())
			}

			guard passcode == confirm else {
				return alert(R.string.localizable.error_register_passwords_do_not_match())
			}

			Service.wallet.importKey(privateKey.rawPrivateKey(), passcode: passcode) { account in
				if account != nil {
					self.createAccount(name: eosName, publicKey: self.publicKey)
				}
				else {
					self.alert(WalletError.unknown)
				}
			}
		}
		else {
			createAccount(name: eosName, publicKey: publicKey)
		}

		view.endEditing(true)
	}

	@IBAction func newKeypair() {
		guard let key = PrivateKey.randomPrivateKey() else {
			return alert(WalletError.unknown) {
				self.navigationController?.popViewController(animated: true)
			}
		}

		privateKey = key
		publicKey = PublicKey(privateKey: key).rawPublicKey()
		showKey()
	}

	// MARK: - Methods

	private func createAccount(name:EosName, publicKey:String) {
		Service.api.createAccount(withName: name.string, publicKey: publicKey) { result in
			switch result {
			case .success(let response):
				if let error = ErrorHandler.error(from: response.result) {
					self.alert(error)
				}
				else {
					self.alert(R.string.localizable.alert_eos_account_created()) {
						Service.presenter.replaceWithWalletViewController(viewController: self)
						Service.settings.setDidCreateEosAccount()
					}
				}
			case .failure(let error):
				self.alert(ErrorHandler.message(for: error))
			}
		}
	}

	private func showKey() {
		keyLabel.text =  R.string.localizable.public_key_display(publicKey)
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
