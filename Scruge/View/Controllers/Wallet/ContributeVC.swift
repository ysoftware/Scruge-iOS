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

	@IBOutlet weak var amountField: UITextField!
	@IBOutlet weak var amountLabel: UILabel!
	@IBOutlet weak var contributedLabel: UILabel!
	@IBOutlet weak var infoLabel: UILabel!

	// MARK: - Actions

	@IBAction func contributeTapped(_ sender: Any) {
		contribute()
	}

	// MARK: - Properties

	var vm:CampaignVM!

	var amountSCR:Double? {
		guard let usd = Double(amountField.text!) else { return nil }
		return convertToSCR(usd)
	}

	// MARK: - Setup

	override func viewDidLoad() {
		super.viewDidLoad()

		setupInformation()
		setupField()
	}

	private func setupField() {
		amountField.delegate = self
		amountField.becomeFirstResponder()
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
			self.contributedLabel.text = "Already contributed: $\(usd)"
		}

		infoLabel.text = vm.contributionInformation
	}

	// MARK: - Methods

	private func convertToSCR(_ amount:Double) -> Double {
		return amount * conversionRate
	}

	private func convertToUSD(_ amount:Double) -> Double {
		return amount / conversionRate
	}

	private func contribute() {
		guard let amountSCR = amountSCR else { return alert("Enter valid contribution amount") }

//		self.vm.contribute(amountSCR, account: account, passcode: passcode) { error in
//			if let error = error {
//				self.alert(error)
//			}
//			else {
//				self.alert("Transaction was successful.") {
//					self.navigationController?.popViewController(animated: true)
//				}
//			}
//		}
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
			amountLabel.text = "= \(scr) SCR"
		}
		else {
			amountLabel.text = "= 0 SCR"
		}
		return true
	}
}
