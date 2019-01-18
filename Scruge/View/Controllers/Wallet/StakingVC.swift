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
	var systemToken:Token { return Service.eos.isMainNet ? .EOS : .SYS }

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

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
		makeNavbarNormal(with: "Stake Resources")
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
		guard let cpuValue = Double(cpuString) else { return alert("Incorrect CPU amount") }
		if (cpuValue < 0.0001 && cpuValue != 0.0) {
			return alert("CPU staking amount is too low")
		}

		let netStr = stakeNetField.text ?? ""
		let netString = netStr.isEmpty ? "0" : netStr
		guard let netValue = Double(netString) else { return alert("Incorrect NET amount") }
		if (netValue < 0.0001 && netValue != 0.0) {
			return alert("NET staking amount is too low")
		}

		if netValue == 0 && cpuValue == 0 {
			return alert("Incorrect staking amount")
		}

		let cpu = Balance(token: systemToken, amount: cpuValue)
		let net = Balance(token: systemToken, amount: netValue)

		guard let passcode = passcodeField.text, passcode.count > 0 else {
			return alert("Enter your wallet password")
		}

		view.endEditing(true)
		Service.eos.stakeResources(account: model, cpu: cpu, net: net, passcode: passcode) { result in
			switch result {
			case .success:
				self.alert("Transaction was successful!") {
					self.navigationController?.popViewController(animated: true)
				}
			case .failure(let error):
					self.alert(error)
			}
		}
	}

	private func updateViews() {
		stakeCurrencyLabels.forEach { $0.text = systemToken.symbol }
		resourcesView.accountName = accountVM?.name

		guard let name = accountVM?.name else { return }
		Service.eos.getBalance(for: name, tokens: [systemToken]) { response in
			if !response.isEmpty {
				self.availableLabel.text = "\(response[0]) available"
			}
			else {
				self.availableLabel.text = "\(Balance(token: self.systemToken, amount: 0.0)) available"
			}
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
