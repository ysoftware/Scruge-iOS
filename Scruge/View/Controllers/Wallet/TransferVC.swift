//
//  TransferVC.swift
//  Scruge
//
//  Created by ysoftware on 21/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class TransferViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var totalLabel: UILabel!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var button: Button!
	@IBOutlet weak var memoField: UITextField!
	@IBOutlet weak var passcodeField: UITextField!
	@IBOutlet weak var receiverField: UITextField!
	@IBOutlet weak var tokenField: UITextField!
	@IBOutlet weak var amountField: FormTextField!

	// MARK: - Properties

	var accountVM:AccountVM!
	private var balances:[Balance] = []
	private var selectedIndex = 0

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupViews()
		setupKeyboard()
		setupActions()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}

	private func setupViews() {
		nameLabel.text = accountVM.displayName
		guard let eosName = accountVM.name else { return }

		Service.api.getDefaultTokens { result in
			let otherTokens = result.value ?? []
			let savedTokens:[String] = Service.settings.get(.userTokens) ?? []
			let userTokens = savedTokens.compactMap { Token(string: $0) }
			let list = Token.default + userTokens + otherTokens

			Service.eos.getBalance(for: eosName, tokens: list) { response in
				self.balances = response.filter { $0.amount != 0 }.distinct

				DispatchQueue.main.async {
					let i = self.balances.firstIndex(where: { $0.token == Service.eos.systemToken }) ?? 0
					self.tokenField.placeholder = self.balances[i].token.symbol
					self.totalLabel.text = self.balances[i].string
					self.selectedIndex = i
				}
			}
		}
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.isHidden = false
		makeNavbarNormal(with: "Transfer Tokens")
		preferSmallNavbar()
	}

	@IBAction func tokenTapped(_ sender: Any) {
		Service.presenter
			.presentPickerController(in: self,
									 with: balances.map { $0.token.symbol },
									 andTitle: "Select token") { i in
										guard let i = i else { return }
										self.selectedIndex = i
										self.totalLabel.text = self.balances[i].string
										self.tokenField.placeholder = self.balances[i].token.symbol
		}
	}

	private func setupActions() {
		button.addClick(self, action: #selector(send))
	}

	// MARK: - Methods

	@objc func send(_ sender:Any) {
		view.endEditing(true)

		guard let model = accountVM.model else {
			return alert("An error occured") {
				self.navigationController?.popViewController(animated: true)
			}
		}

		guard (balances.count > selectedIndex) else {
			return alert("An error occured. Select correct token to transfer") {
				if (!self.balances.isEmpty) {
					self.selectedIndex = 0
					self.totalLabel.text = self.balances[0].string
					self.tokenField.placeholder = self.balances[0].token.symbol
				}
				else {
					self.navigationController?.popViewController(animated: true)
				}
			}
		}

		let token = balances[selectedIndex].token
		let name = receiverField.text ?? ""
		let memo = memoField.text ?? ""
		let passcode = passcodeField.text ?? ""

		guard passcode.count > 0 else {
			return alert("Enter your wallet password")
		}

		guard let amount = Double(amountField.text ?? ""), amount >= 0.0001 else {
			return alert("Incorrect amount value")
		}

		guard let recipient = name.eosName else {
			return alert(EOSError.incorrectName)
		}


		let balance = Balance(token: token, amount: amount)
		Service.eos.sendMoney(from: model,
							  to: recipient,
							  balance: balance,
							  memo: memo,
							  passcode: passcode) { result in
								switch result {
								case .success:
									self.alert("Transaction was successful") {
										self.navigationController?.popViewController(animated: true)
									}
								case .failure(let error):
									self.alert(error)
								}
		}
	}
}

extension TransferViewController {

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
	}

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
