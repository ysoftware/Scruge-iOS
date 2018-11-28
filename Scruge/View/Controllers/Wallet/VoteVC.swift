//
//  VoteVC.swift
//  Scruge
//
//  Created by ysoftware on 15/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class VoteViewController: UIViewController {

	@IBOutlet weak var yesButton:UIButton!
	@IBOutlet weak var noButton:UIButton!
	@IBOutlet weak var passcodeField: UITextField!
	
	var vm:CampaignVM!
	private let accountVM = AccountAVM()

	override func viewDidLoad() {
		super.viewDidLoad()

		accountVM.reloadData()
	}

	@IBAction func vote(_ sender:UIButton) {
		guard accountVM.numberOfItems > 0 else {
			return alert("You don't have your blockchain account setup")
		}

		guard let passcode = passcodeField.text, passcode.count > 0 else {
			return alert("Enter your wallet passcode")
		}

		let account = accountVM.item(at: 0)
		let value = sender == yesButton

		self.vm.vote(value, account: account, passcode: passcode) { error in
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
