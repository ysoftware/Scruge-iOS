//
//  ImportKeyVC.swift
//  Scruge
//
//  Created by ysoftware on 18/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ImportKeyViewController: UIViewController {

	@IBOutlet weak var textView:UITextView!

	override func viewDidLoad() {
		setupNavigationBar()
		textView.becomeFirstResponder()
	}

	func setupNavigationBar() {
		let saveButton = UIBarButtonItem(title: "Save key",
										 style: .plain,
										 target: self,
										 action: #selector(save))
		navigationItem.rightBarButtonItem = saveButton
	}

	@objc func save(_ sender:Any) {
		let message = "Enter new passcode for this account"
		Presenter .presentPasscodeViewController(in: self, message: message) { input in
			guard let passcode = input else { return }

			Service.wallet.importKey(self.textView.text, passcode: passcode) { account in
				if account != nil {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
						self.navigationController?.popViewController(animated: true)
					}
				}
				else {
					self.alert("Error: Could not import this key")
				}
			}
		}
	}
}
