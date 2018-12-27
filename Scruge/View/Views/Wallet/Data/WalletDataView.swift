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

	// MARK: - Properties

	var copyPublicKeyTap:((SELocalAccount?)->Void)?
	var exportPrivateKeyTap:((SELocalAccount?)->Void)?

	private var wallet:SELocalAccount?

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

	func updateViews() {
		wallet = Service.wallet.getWallet()
		publicKeyLabel.text = wallet?.rawPublicKey
	}

	// MARK: - Actions

	@IBAction func copyPublicKey(_ sender: Any) {
		copyPublicKeyTap?(wallet)
	}

	@IBAction func exportPrivateKey(_ sender: Any) {
		exportPrivateKeyTap?(wallet)
	}
}
