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

	var vm:CampaignVM!

	@IBAction func vote(_ sender:UIButton) {
		let value = sender == yesButton

		Service.presenter.presentWalletPicker(in: self) { [unowned self] account in
			guard let account = account else {
				return
			}

			let message = "Unlock the wallet to vote."
			Service.presenter.presentPasscodeViewController(in: self, message: message) { passcode in
				guard let passcode = passcode else {
					return
				}

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
	}
}
