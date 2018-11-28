//
//  ImportKeyVC.swift
//  Scruge
//
//  Created by ysoftware on 18/10/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class ImportKeyViewController: UIViewController {

	@IBOutlet weak var passcodeField:UITextField!
	@IBOutlet weak var keyField:UITextField!
	@IBOutlet weak var button:Button!

	override func viewDidLoad() {
		super.viewDidLoad()

		keyField.becomeFirstResponder()
		button.addClick(self, action: #selector(createAccount))
		setupNavigationBar()
	}

	func setupNavigationBar() {
		title = "Import key"

		if #available(iOS 11.0, *) {
			navigationController?.navigationBar.prefersLargeTitles = false
		}
	}

	@IBAction func createAccount(_ sender:Any) {
		Service.presenter.replaceWithCreateAccountViewController(with: self)
	}

	@IBAction func save(_ sender:Any) {
		let accountName = keyField.text ?? ""
		let passcode = passcodeField.text ?? ""

		// if existed
		Service.wallet.deleteWallet()

		Service.wallet.importKey(accountName, passcode: passcode) { account in
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
