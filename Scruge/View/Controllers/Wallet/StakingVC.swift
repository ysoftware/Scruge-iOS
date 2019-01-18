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

		let cpu = Balance(token: systemToken, amount: cpuValue)
		let net = Balance(token: systemToken, amount: netValue)

		guard let passcode = passcodeField.text, passcode.count > 0 else {
			return alert("Enter your wallet password")
		}

		view.endEditing(true)
		Service.eos.stakeResources(account: model, cpu: cpu, net: net, passcode: passcode) { result in
			switch result {
			case .success:
				self.alert("Success!")
				self.navigationController?.popViewController(animated: true)
			case .failure(let error):
					self.alert(error)
			}
		}
	}
	
}
