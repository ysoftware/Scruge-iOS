//
//  StakingVC.swift
//  Scruge
//
//  Created by ysoftware on 17/01/2019.
//  Copyright © 2019 Ysoftware. All rights reserved.
//

import UIKit

final class StakingViewController:UIViewController {

	// MARK: - Outlets

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var resourcesView: ResourcesView!
	@IBOutlet weak var button: Button!
	@IBOutlet weak var passcodeField: UITextField!
	@IBOutlet weak var availableLabel: UILabel!
	@IBOutlet var stakeCurrencyLabels: [UILabel]!
	@IBOutlet weak var stakeCpuField: FormTextField!
	@IBOutlet weak var stakeNetField: FormTextField!

	// MARK: - Properties
	
	var accountVM:AccountVM!

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setup()
		setupKeyboard()
		updateViews()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
											   name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
											   name:UIResponder.keyboardWillHideNotification, object: nil)
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.isHidden = false
		makeNavbarNormal(with: R.string.localizable.title_manage_resources())
		preferSmallNavbar()
	}

	private func setup() {
		button.addClick(self, action: #selector(send))
	}

	// MARK: - Methods

	@objc func send(_ sender:Any) {
		guard let model = accountVM.model else { return }

		let cpuStr = stakeCpuField.text ?? ""
		let cpuString = cpuStr.isEmpty ? "0" : cpuStr
		guard let cpuValue = Double(cpuString) else {
			return alert(R.string.localizable.error_wallet_invalid_amount())
		}
		if (cpuValue < 0.0001 && cpuValue != 0.0) {
			return alert(R.string.localizable.error_wallet_invalid_amount())
		}

		let netStr = stakeNetField.text ?? ""
		let netString = netStr.isEmpty ? "0" : netStr
		guard let netValue = Double(netString) else {
			return alert(R.string.localizable.error_wallet_invalid_amount())
		}
		if (netValue < 0.0001 && netValue != 0.0) {
			return alert(R.string.localizable.error_wallet_invalid_amount())
		}

		if netValue == 0 && cpuValue == 0 {
			return alert(R.string.localizable.error_wallet_invalid_amount())
		}

		let systemToken = Service.eos.systemToken
		let cpu = Balance(token: systemToken, amount: cpuValue)
		let net = Balance(token: systemToken, amount: netValue)

		guard let passcode = passcodeField.text, passcode.count > 0 else {
			return alert(R.string.localizable.error_wallet_enter_wallet_password())
		}

		view.endEditing(true)
		Service.eos.stakeResources(account: model, cpu: cpu, net: net, passcode: passcode) { result in
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

	private func updateViews() {
		let systemToken = Service.eos.systemToken
		stakeCurrencyLabels.forEach { $0.text = systemToken.symbol }
		resourcesView.accountName = accountVM?.name

		guard let name = accountVM?.name else { return }
		Service.eos.getBalance(for: name, tokens: [systemToken]) { response in
			let balance = response.first ?? Balance(token: systemToken, amount: 0.0)
			self.availableLabel.text = R.string.localizable.tokens_available(balance.string)
		}
	}
}

extension StakingViewController {

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
