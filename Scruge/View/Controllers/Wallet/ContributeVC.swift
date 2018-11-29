//
//  ContributeVC.swift
//  Scruge
//
//  Created by ysoftware on 15/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ContributeViewController: UIViewController {

	let conversionRate = 1.5 // $ for 1 SCR

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

	@objc func contributeTapped(_ sender: Any) {
		contribute()
	}

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	@IBAction func checkmarkTapped(_ sender:Any) {
		checkmarkView.backgroundColor = !isChecked ? Service.constants.color.purple : .white
		button.color = !isChecked ? Service.constants.color.purple : Service.constants.color.gray
	}

	// MARK: - Properties

	var vm:CampaignVM!
	let accountVM = AccountAVM()

	var amountSCR:Double? {
		guard let usd = Double(usdField.text!) else { return nil }
		return convertToSCR(usd)
	}

	var isChecked:Bool {
		return checkmarkView.backgroundColor == Service.constants.color.purple
	}

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupInformation()
		setupField()
		button.addClick(self, action: #selector(contributeTapped))
		checkmarkView.backgroundColor = .white
		button.color = Service.constants.color.gray
		setupKeyboard()
	}

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupField() {
		scrField.delegate = self
		usdField.delegate = self
		scrField.becomeFirstResponder()
	}

	private func setupInformation() {
		vm.loadAmountContributed { value in
			guard let value = value else {
				return self.alert("Could not load information.") {
					self.navigationController?.popViewController(animated: true)
				}
			}
			let usd = self.convertToUSD(value)
				.format(as: .decimal, separateWith: " ")
			self.contributedLabel.text = "You have already contributed $\(usd) in this project"
			self.contributedLabel.isHidden = value == 0
		}
	}

	// MARK: - Methods

	private func convertToSCR(_ amount:Double) -> Double {
		return amount * conversionRate
	}

	private func convertToUSD(_ amount:Double) -> Double {
		return amount / conversionRate
	}

	private func contribute() {
		guard isChecked else { return }

		guard let account = accountVM.selectedAccount else {
			return alert("You don't have your blockchain account set up")
		}

		guard let amountSCR = amountSCR else { return alert("Enter valid contribution amount") }

		guard let passcode = passcodeField.text, passcode.count > 0 else {
			return alert("Enter your wallet password")
		}

		self.vm.contribute(amountSCR, account: account, passcode: passcode) { error in
			if let error = error {
				self.alert(error)
			}
			else {
				self.alert("Transaction was successful.") {
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

		if let usd = Double(updatedText) {
			let scr = convertToSCR(usd)
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
