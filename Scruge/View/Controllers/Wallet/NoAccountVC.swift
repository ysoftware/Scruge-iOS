//
//  WalletNoAccountVC.swift
//  Scruge
//
//  Created by ysoftware on 29/11/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

final class WalletNoAccountViewController: UIViewController {

	@IBOutlet weak var walletDataView: WalletDataView!
	@IBOutlet var createButton:Button!
	@IBOutlet var privacyLabel:UILabel!

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		localize()
		setupButton()
		NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification,
											   object: nil, queue: nil) { _ in
												self.walletDataView.lock()
		}
		walletDataView.presentingViewController = self
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		walletDataView.lock()
	}

	private func setupButton() {
		createButton.addClick(self, action: #selector(createAccount))
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.navigationBar.isHidden = false
		navigationController?.preferLargeNavbar()
	}

	@objc func createAccount(_ sender:Any) {
		guard Service.tokenManager.hasToken else {
			return alert("Please sign in with your Scruge account first")
		}
		Service.presenter.presentCreateAccountViewController(in: self)
	}

	@IBAction func importKey(_ sender:Any) {
		let t = "Are you sure to delete your wallet?"
		let q = "Make sure to export your private key because there is no way it can be retrieved later."
		self.ask(title: t, question: q) { response in
			if response {
				Service.wallet.deleteWallet()
				Service.presenter.replaceWithWalletStartViewController(viewController: self)
			}
		}
	}

	@IBAction func showWalletData(_ sender: Any) {
		walletDataView.lock()
		walletDataView.isHidden.toggle()
	}

	@IBAction func openPrivacy(_ sender:Any) {
		Service.presenter.presentPrivacyPolicy(in: self)
	}
}
