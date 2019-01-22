//
//  WalletStartVC.swift
//  Scruge
//
//  Created by ysoftware on 29/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class WalletStartViewController: UIViewController {

	@IBOutlet var addButton:Button!
	@IBOutlet var privacyLabel:UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		setupButton()
	}

	private func setupButton() {
		addButton.addClick(self, action: #selector(importKey))
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		navigationController?.navigationBar.isHidden = true
		navigationController?.preferLargeNavbar()
		if Service.wallet.getWallet() != nil {
			Service.presenter.replaceWithWalletViewController(viewController: self)
		}
	}

	@IBAction func createAccount(_ sender:Any) {
		guard Service.tokenManager.hasToken else {
			return alert("Please sign in with your Scruge account first")
		}
		Service.presenter.presentCreateAccountViewController(in: self)
	}

	@objc func importKey() {
		Service.presenter.presentImporKeyViewController(in: self)
	}

	@IBAction func openPrivacy(_ sender:Any) {
		#warning("open privacy")
	}
}
