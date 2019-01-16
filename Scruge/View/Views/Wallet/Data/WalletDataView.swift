//
//  WalletDataView.swift
//  Scruge
//
//  Created by ysoftware on 26/12/2018.
//  Copyright © 2018 Ysoftware. All rights reserved.
//

import UIKit

@IBDesignable
final class WalletDataView: UIView {

	@IBOutlet var contentView: UIView!
	@IBOutlet weak var publicKeyLabel: UILabel!
	@IBOutlet weak var privateKeyLabel: UILabel!

	// MARK: - Properties

	public weak var presentingViewController:UIViewController?
	private var wallet:SELocalAccount?
	private var unlocked = false

	// MARK: - Setup

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	private func setup() {
		Bundle.main.loadNibNamed("WalletDataView", owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		contentView.backgroundColor = .clear
		self.backgroundColor = .clear
	}

	func lock() {
		makeSecure(false)
		updateViews()
	}

	func updateViews() {
		makeSecure(false)
		privateKeyLabel.text = "5••••••••••••••••••••••••••••••••••••••••••••••••••"

		wallet = Service.wallet.getWallet()
		publicKeyLabel.text = wallet?.rawPublicKey
	}

	private func makeSecure(_ value: Bool) {
		unlocked = value
		// TO-DO: make secure
	}

	// MARK: - Actions

	@IBAction func copyPublicKey(_ sender: Any) {
		UIPasteboard.general.string = wallet?.rawPublicKey
		presentingViewController?.alert("Copied to clipboard")
	}

	@IBAction func exportPrivateKey(_ sender: Any) {
		if unlocked {
			UIPasteboard.general.string = privateKeyLabel.text
			self.presentingViewController?.alert("Copied to clipboard")
		}

		guard let wallet = Service.wallet.getWallet() else { return }
		let warning = "Be careful not to share your private key with anyone!"

		presentingViewController?.askForInput("Export private key",
						 question: "Enter your wallet password",
						 placeholder: "Wallet password…",
						 keyboardType: .default,
						 isSecure: true,
						 actionTitle: "Unlock") { input in
							guard let input = input else { return }
							guard let privateKey = try? wallet.decrypt(passcode: input) else {
								self.presentingViewController?.alert("Incorrect password")
								return
							}
							self.privateKeyLabel.text = privateKey.rawPrivateKey()
							self.presentingViewController?.alert(warning)
		}
	}
}
