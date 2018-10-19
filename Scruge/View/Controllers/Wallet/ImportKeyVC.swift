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
										 target: self, action: #selector(save))
		navigationItem.rightBarButtonItem = saveButton
	}

	@objc func save(_ sender:Any) {
		Service.wallet.importKey(textView.text, passcode: PASSCODE) { account in
			if account != nil {
				self.navigationController?.popViewController(animated: true)
			}
			else {
				self.alert("Error has occured")
			}
		}
	}
}
