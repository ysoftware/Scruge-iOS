//
//  VoteVC.swift
//  Scruge
//
//  Created by ysoftware on 15/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class VoteViewController: UIViewController {

	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var yesButton:UIButton!
	@IBOutlet weak var noButton:UIButton!
	@IBOutlet weak var passcodeField: UITextField!
	
	var vm:CampaignVM!
	private let accountVM = AccountAVM()

	override func viewDidLoad() {
		super.viewDidLoad()

		accountVM.reloadData()
	}

	@IBAction func hideKeyboard(_ sender: Any) {
		view.endEditing(true)
	}

	private func setupKeyboard() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@IBAction func vote(_ sender:UIButton) {
		guard let account = accountVM.selectedAccount else {
			// TO-DO: check if maybe should open wallet picker right there?
			return alert("You don't have your blockchain account setup")
		}

		guard let passcode = passcodeField.text, passcode.count > 0 else {
			return alert("Enter your wallet passcode")
		}

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

extension VoteViewController {

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
