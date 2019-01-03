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
		setupButton()
	}

	private func setupButton() {
		createButton.addClick(self, action: #selector(importKey))
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBar.isHidden = false
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
		#warning("open privacy")
	}
}
