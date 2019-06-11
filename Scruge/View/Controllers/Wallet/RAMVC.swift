//
//  RAMVC.swift
//  Scruge
//
//  Created by ysoftware on 20/02/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

import MVVM

final class RAMViewController: UIViewController {

	private enum Action: CaseIterable {

		case buyBytes, buyEOS, sell

		var label:String {
			switch self {
			case .sell: return R.string.localizable.label_sell_ram()
			case .buyBytes: return R.string.localizable.label_buy_ram_bytes()
			case .buyEOS: return R.string.localizable.label_buy_ram_eos()
			}
		}
	}

	// MARK: - Outlets

	@IBOutlet weak var scrollView:UIScrollView!
	@IBOutlet weak var pickerField: UITextField!
	@IBOutlet weak var resourcesView: ResourcesView!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var button: Button!
	@IBOutlet weak var amountField: FormTextField!
	@IBOutlet weak var passwordField: UITextField!

	// MARK: - Properties

	var accountVM:AccountVM!
	private var action = Action.buyBytes
	private var price:Double = 0.0

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupViews()
		setupActions()
		setupNavigationBar()
		setupKeyboard()
		updateViews()
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.isHidden = false
		makeNavbarNormal(with: R.string.localizable.title_manage_ram())
		preferSmallNavbar()
	}

	private func setupViews() {
		resourcesView.accountName = accountVM.name
		pickerField.placeholder = Action.allCases.first?.label

		Service.eos.getRAMPrice { result in
			switch result {
			case .success(let value):
				let price = (value * 1024).formatRounding(to: 4, min: 4)
				self.price = value
				self.priceLabel.text = R.string.localizable.current_ram_price(price)
			case .failure(let error):
				self.alert(error)
			}
			self.updateViews()
		}
	}

	private func setupActions() {
		button.addClick(self, action: #selector(send))
		amountField.delegate = self
	}

	// MARK: - Actions

	@IBAction func pickerTapped(_ sender: Any) {
		let title = R.string.localizable.title_select_action()
		let actions = Action.allCases.map { $0.label }

		view.endEditing(true)
		Service.presenter.presentPickerController(in: self, with: actions, andTitle: title) { position in
			guard let position = position else { return }
			self.action = Action.allCases[position]
			self.pickerField.placeholder = self.action.label
			self.updateViews()
		}
	}
	
	// MARK: - Methods

	private func updateViews(_ text:String = "") {
		let input = Double(text) ?? 0

		switch action {
		case .sell:
			let value = (price * input.rounded()).formatRounding(to: 4, min: 4)
			button.text = R.string.localizable.do_sell_eos_ram(value)
		case .buyBytes:
			let value = (price * input.rounded()).formatRounding(to: 4, min: 4)
			button.text = R.string.localizable.do_buy_bytes_ram(value)
		case .buyEOS:
			let value = (input / price).formatRounding(to: 0, min: 0)
			button.text = R.string.localizable.do_buy_eos_ram(value)
		}
	}

	@objc func send(_ sender:Any) {
		guard let model = accountVM?.model else {
			return alert(GeneralError.implementationError)
		}

		guard let input = Double(amountField.text!) else {
			return alert(R.string.localizable.error_incorrect_input())
		}

		let passcode = passwordField.text ?? ""
		guard passcode.count > 0 else {
			return alert(R.string.localizable.error_wallet_enter_wallet_password())
		}

		self.button.isBusy = true
		switch action {
		case .sell:
			Service.eos.sellRam(account: model, bytes: Int64(input), passcode: passcode, block)
		case .buyBytes:
			Service.eos.buyRam(account: model, bytes: Int64(input), passcode: passcode, block)
		case .buyEOS:
			let amount = Balance(token: .EOS, amount: input)
			Service.eos.buyRam(account: model, amount: amount, passcode: passcode, block)
		}
	}

	func block(_ result:Result<String, Error>) {
		self.button.isBusy = false
		
		switch result {
		case .success:
			self.alert(R.string.localizable.alert_transaction_success()) {
				self.navigationController?.popViewController(animated: true)
			}
		case .failure(let error):
			self.alert(error)
		}
	}
}

extension RAMViewController: UITextFieldDelegate {

	func textField(_ textField: UITextField,
				   shouldChangeCharactersIn range: NSRange,
				   replacementString string: String) -> Bool {

		let text = textField.text ?? ""
		let textRange = Swift.Range(range, in: text)!
		let updatedText = text.replacingCharacters(in: textRange,
												   with: string.replacingOccurrences(of: ",", with: "."))

		updateViews(updatedText)
		return true
	}
}

extension RAMViewController {

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
											   name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
											   name:UIResponder.keyboardWillHideNotification, object: nil)
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
