//
//  ContributeVC.swift
//  Scruge
//
//  Created by ysoftware on 15/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ContributeViewController: UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var passcodeField: UITextField!
	@IBOutlet weak var scrField: UITextField!
	@IBOutlet weak var usdField: UITextField!

	@IBOutlet weak var button: Button!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var contributedLabel: UILabel!
	@IBOutlet weak var checkmarkView: UIView!

	// MARK: - Actions

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	@IBAction func checkmarkTapped(_ sender:Any) {
		let newValue = !isChecked
		checkmarkView.backgroundColor = newValue ? Service.constants.color.purple : .white
		button.color = newValue ? Service.constants.color.purple : Service.constants.color.gray
	}

	// MARK: - Properties

	var vm:CampaignVM!
	let accountVM = AccountAVM()

	var amountSCR:Double? {
		guard let usd = Double(usdField.text!) else { return nil }
		return Service.exchangeRates.convert(Quantity(usd, .usd), to: .scr)?.amount
	}

	var isChecked:Bool {
		return checkmarkView.backgroundColor == Service.constants.color.purple
	}

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupInformation()
		setupField()
		setupVM()
		setupButton()
		setupKeyboard()
		setupView()
	}

	private func setupView() {
		checkmarkView.backgroundColor = .white
		button.color = Service.constants.color.gray
	}

	private func setupVM() {
		accountVM.reloadData()
	}

	private func setupButton() {
		button.addClick(self, action: #selector(contribute))
	}

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
											   name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
											   name:UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupField() {
		scrField.delegate = self
		usdField.delegate = self
		scrField.becomeFirstResponder()
	}

	private func setupInformation() {
		vm.loadAmountContributed { value in
			guard let value = value else {
				return self.alert(R.string.localizable.error_wallet_no_transferable_tokens())
			}

			let usd = (Service.exchangeRates.convert(Quantity(value, .scr), to: .usd)?.amount ?? 0)
				.formatDecimal(separateWith: " ")

			self.contributedLabel.text = R.string.localizable.label_you_have_contributed_usd(usd)
			self.contributedLabel.isHidden = value == 0
		}
		titleLabel.text = R.string.localizable.title_invest_in(vm.title)
	}

	// MARK: - Methods

	@objc private func contribute() {
		guard isChecked else { return }

		guard let account = accountVM.selectedAccount else {
			return alert(R.string.localizable.error_wallet_not_setup())
		}

		guard let amountSCR = amountSCR else {
			return alert(R.string.localizable.error_wallet_invalid_amount())
		}

		guard let passcode = passcodeField.text, passcode.count > 0 else {
			return alert(R.string.localizable.error_wallet_enter_wallet_password())
		}

		self.button.isBusy = true
		
		self.vm.contribute(amountSCR, account: account, passcode: passcode) { error in
			self.button.isBusy = false

			if let error = error {
				self.alert(error)
			}
			else {
				self.alert(R.string.localizable.alert_transaction_success()) {
					self.navigationController?.popViewController(animated: true)
				}
			}
		}
	}
}

extension ContributeViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {

		let text = textField.text ?? ""
		let textRange = Swift.Range(range, in: text)!
		let updatedText = text.replacingCharacters(in: textRange,
												   with: string.replacingOccurrences(of: ",", with: "."))

		if let usd = Double(updatedText),
			let scr = Service.exchangeRates.convert(Quantity(usd, .usd), to: .scr)?.amount {
			scrField.text = "\(scr) SCR"
		}
		else {
			scrField.text = "0 SCR"
		}
		return true
	}
}

extension ContributeViewController {

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
