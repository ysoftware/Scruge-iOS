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
		localize()
	}

	func lock() {
		unlocked = false
		updateViews()
	}

	func updateViews() {
		unlocked = false
		privateKeyLabel.text = "5••••••••••••••••••••••••••••••••••••••••••••••••••"

		wallet = Service.wallet.getWallet()
		publicKeyLabel.text = wallet?.rawPublicKey
	}

	// MARK: - Actions

	@IBAction func copyPublicKey(_ sender: Any) {
		UIPasteboard.general.string = wallet?.rawPublicKey
		presentingViewController?.alert(R.string.localizable.alert_copied_to_clipboard())
	}

	@IBAction func exportPrivateKey(_ sender: Any) {
		if unlocked {
			UIPasteboard.general.string = privateKeyLabel.text
			presentingViewController?.alert(R.string.localizable.alert_copied_to_clipboard())
			return
		}

		guard let wallet = Service.wallet.getWallet() else { return }
		let warning =  R.string.localizable.alert_private_key_warning()

		presentingViewController?.askForInput(R.string.localizable.title_export_private_key(),
						 question: R.string.localizable.label_export_private_key(),
						 placeholder: R.string.localizable.hint_wallet_password(),
						 keyboardType: .default,
						 isSecure: true,
						 actionTitle: R.string.localizable.do_unlock_wallet()) { input in
							guard let input = input else { return }
							guard let privateKey = try? wallet.decrypt(passcode: input) else {

								self.presentingViewController?.alert(
									R.string.localizable.error_incorrectPassword())
								return
							}
							self.unlocked = true
							self.privateKeyLabel.text = privateKey.rawPrivateKey()
							self.presentingViewController?.alert(warning)
		}
	}
}
