//
//  WalletNoAccountVC.swift
//  Scruge
//
//  Created by ysoftware on 29/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class WalletNoAccountViewController: UIViewController {

	@IBOutlet var createButton:Button!
	@IBOutlet var privacyLabel:UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		createButton.addClick(self, action: #selector(createAccount))
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.preferLargeNavbar()
	}

	@objc func createAccount(_ sender:Any) {
		Service.presenter.presentCreateAccountViewController(in: self)
	}

	@IBAction func importKey(_ sender:Any) {
		Service.wallet.deleteWallet()
		Service.presenter.replaceWithImporKeyViewController(with: self)
	}

	@IBAction func openPrivacy(_ sender:Any) {
		// TO-DO: open privacy
	}
}
